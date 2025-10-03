from firebase_admin import firestore
from google.cloud.firestore_v1.base_query import FieldFilter


def get_total_amount_for_job(job_id: str) -> float:
    db = firestore.client()
    total = 0.0
    receipts_ref = db.collection('all_receipts').where(
        filter=FieldFilter('job_ids', 'array_contains', job_id)
    )
    receipts = receipts_ref.stream()
    for receipt in receipts:
        receipt_data = receipt.to_dict()
        jobs = receipt_data.get('jobs', {})
        total += float(jobs.get(job_id, 0))
    return total
