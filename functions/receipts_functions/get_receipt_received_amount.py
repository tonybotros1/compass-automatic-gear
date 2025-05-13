from firebase_functions import https_fn
from firebase_admin import firestore
from google.cloud.firestore_v1.base_query import FieldFilter


@https_fn.on_call()
def get_receipt_received_amount(data: https_fn.CallableRequest) -> float:
    try:
        receipt_id = data.data
        if not receipt_id:
            raise ValueError("Missing receipt_id")
        db = firestore.client()
        receipt_ref = db.collection('all_receipts').document(receipt_id)
        receipts = receipt_ref.get()
        receipts_data = receipts.to_dict()
        jobs = receipts_data.get('jobs', {})
        total_received_amount = sum(float(amount) for amount in jobs.values())

        return {'total_received_amount': total_received_amount}

    except Exception as e:
        raise https_fn.HttpsError("internal", f"Error: {str(e)}")
