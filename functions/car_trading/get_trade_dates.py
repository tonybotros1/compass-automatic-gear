from firebase_functions import https_fn
from firebase_admin import firestore
from google.cloud.firestore_v1.base_query import FieldFilter


@https_fn.on_call()
def get_sell_date(data: https_fn.CallableRequest) -> str:
    try:
        trade_id = data.data
        sell_date = ''
        if not trade_id:
            raise ValueError("Missing tradeId")
        db = firestore.client()

        doc_ref = db.collection("all_trades").document(trade_id)
        doc = doc_ref.get()
        items = []

        if doc.exists:
            items = doc.get('items') or []

        for item in items:
            my_item = item.get('item', '')
            my_item_name = get_item_name(my_item)
            if my_item_name == 'SELL':
                sell_date = item.get('date', '')
                continue

        return sell_date

    except Exception as e:
        raise https_fn.HttpsError("internal", f"Error: {str(e)}")
    

@https_fn.on_call()
def get_buy_date(data: https_fn.CallableRequest) -> str:
    try:
        trade_id = data.data
        sell_date = ''
        if not trade_id:
            raise ValueError("Missing tradeId")
        db = firestore.client()

        doc_ref = db.collection("all_trades").document(trade_id)
        doc = doc_ref.get()
        items = []

        if doc.exists:
            items = doc.get('items') or []

        for item in items:
            my_item = item.get('item', '')
            my_item_name = get_item_name(my_item)
            if my_item_name == 'BUY':
                sell_date = item.get('date', '')
                continue

        return sell_date

    except Exception as e:
        raise https_fn.HttpsError("internal", f"Error: {str(e)}")
    


def get_item_name(id: str):
    try:
        db = firestore.client()

        doc_ref = db.collection("all_lists").where(
            filter=FieldFilter('code', '==', 'ITEMS')).get()
        if not doc_ref:
            raise ValueError("No document found with code 'ITEMS'")

        type_id = doc_ref[0].id

        year_doc_ref = (
            db.collection('all_lists')
            .document(type_id)
            .collection('values')
            .document(id)
        )

        item_doc = year_doc_ref.get()

        # Step 3: Return the 'name' field or empty string
        if item_doc.exists:
            return item_doc.to_dict().get("name", "")
        else:
            return ""

    except Exception as e:
        raise https_fn.HttpsError("internal", f"Error: {str(e)}")
