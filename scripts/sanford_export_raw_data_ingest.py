import os
from pathlib import Path
import psycopg2
import shutil

print("SCRIPT FILE:", __file__)
print("CWD:", os.getcwd())

DATA_DIR = Path(r"E:\Project\sanford_analytics\data\input")
PROCESSED_DIR = DATA_DIR / "processed"
REJECT_DIR = DATA_DIR / "reject"

PROCESSED_DIR.mkdir(exist_ok=True)
REJECT_DIR.mkdir(exist_ok=True)

print("Ingestion process started")
print("DATA_DIR:", DATA_DIR)
print("FILES IN DIR:", list(DATA_DIR.iterdir()))

PG = dict(
    host="localhost",
    port=5432,
    dbname="sanford_dwh",
    user="sanford",
    password="sanford"
)

def ingest_raw_data():
    print("Connecting to DB...")
    conn = psycopg2.connect(**PG)
    conn.autocommit = True
    cur = conn.cursor()

    for file in DATA_DIR.iterdir():
        if not file.is_file() or file.suffix.lower() != ".csv":
            continue

        print("File found:", file.name)
        name = file.name.lower()

        if not (name.startswith("exports-by-product-") and name.endswith(".csv")):
            print("Reject bad filename:", file.name)
            shutil.move(file, REJECT_DIR / file.name)
            continue

        year = name[-6:-4]
        if not year.isdigit():
            print("Reject bad year:", file.name)
            shutil.move(file, REJECT_DIR / file.name)
            continue

        fy = f"FY{year}"

        try:
            cur.execute(
                """
                INSERT INTO sanford_audit.batch_details
                (file_name, fiscal_year, status, loaded_start_time)
                VALUES (%s, %s, 'RUNNING', CURRENT_TIMESTAMP)
                RETURNING batch_id
                """,
                (file.name, fy)
            )
            batch_id = cur.fetchone()[0]
            print("Batch started:", batch_id)

            with file.open("r", encoding="utf-8-sig") as f:
                cur.copy_expert(
                    """
                    COPY aquaculture_bronze.staging
                    (species, product, country, volume, value)
                    FROM STDIN
                    WITH CSV HEADER
                    """,
                    f
                )

            cur.execute(
                "UPDATE aquaculture_bronze.staging SET batch_id=%s WHERE batch_id IS NULL",
                (batch_id,)
            )

            cur.execute(
                """
                UPDATE sanford_audit.batch_details
                SET status='LOADED', loaded_end_time=CURRENT_TIMESTAMP
                WHERE batch_id=%s
                """,
                (batch_id,)
            )

            shutil.move(file, PROCESSED_DIR / file.name)
            print("LOADED:", file.name)

        except Exception as e:
            print("FAILED:", file.name, e)

            # mark batch as FAILED
            cur.execute(
                """
                UPDATE sanford_audit.batch_details
                SET status='FAILED',
                    loaded_end_time=CURRENT_TIMESTAMP
                WHERE batch_id=%s
                """,
                (batch_id,)
            )

            shutil.move(file, REJECT_DIR / file.name)

    cur.close()
    conn.close()
    print("Ingestion finished")

if __name__ == "__main__":
    ingest_raw_data()
