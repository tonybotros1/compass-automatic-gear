from firebase_functions import https_fn
from firebase_admin import firestore
from google.cloud.firestore_v1.base_query import FieldFilter


@https_fn.on_call()
def get_trade_total_paid(data: https_fn.CallableRequest) -> float:
    try:
        trade_id = data.data
        total_payed = 0.0
        if not trade_id:
            raise ValueError("Missing tradeId")
        db = firestore.client()

        doc_ref = db.collection("all_trades").document(trade_id)
        doc = doc_ref.get()
        items = []

        if doc.exists:
            items = doc.get('items') or []

        for item in items:
            total_payed += float(item.get('pay', 0))

        return total_payed

    except Exception as e:
        raise https_fn.HttpsError("internal", f"Error: {str(e)}")


@https_fn.on_call()
def get_trade_total_received(data: https_fn.CallableRequest) -> float:
    try:
        trade_id = data.data
        total_received = 0.0
        if not trade_id:
            raise ValueError("Missing tradeId")
        db = firestore.client()

        doc_ref = db.collection("all_trades").document(trade_id)
        doc = doc_ref.get()
        items = []

        if doc.exists:
            items = doc.get('items') or []

        for item in items:
            total_received += float(item.get('receive', 0))

        return total_received

    except Exception as e:
        raise https_fn.HttpsError("internal", f"Error: {str(e)}")


@https_fn.on_call()
def get_trade_total_NETs(data: https_fn.CallableRequest) -> float:
    try:
        trade_id = data.data
        if not trade_id:
            raise ValueError("Missing tradeId")
        db = firestore.client()
        total_received = 0.0
        total_payed = 0.0
        doc_ref = db.collection("all_trades").document(trade_id)
        doc = doc_ref.get()
        items = []

        if doc.exists:
            items = doc.get('items') or []

        for item in items:
            total_received += float(item.get('receive', 0))
            total_payed += float(item.get('pay', 0))
        
        
        return total_received - total_payed

    except Exception as e:
        raise https_fn.HttpsError("internal", f"Error: {str(e)}")
