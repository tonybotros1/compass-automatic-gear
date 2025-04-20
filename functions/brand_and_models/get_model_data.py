from firebase_functions import https_fn
from firebase_admin import firestore
from google.cloud.firestore_v1.base_query import FieldFilter


@https_fn.on_call()
def get_model_name(data: https_fn.CallableRequest) -> str:
    try:
        # Extract the brand and model IDs from the request data.
        brand_id = data.data.get("brandId")
        model_id = data.data.get("modelId")

        if not brand_id or not model_id:
            raise ValueError("Missing brandId or modelId")

        # Access Firestore using the Admin SDK.
        db = firestore.client()
        # Build the document reference path: all_brands/{brand_id}/values/{model_id}
        doc_ref = db.collection("all_brands") \
                    .document(brand_id) \
                    .collection("values") \
                    .document(model_id)
        doc = doc_ref.get()

        # If the document exists, return its 'name' field. Otherwise, return an empty string.
        if doc.exists:
            doc_data = doc.to_dict()
            return doc_data.get("name", "")
        else:
            return ""
    except Exception as e:
        # Raise an HTTPS error if something goes wrong.
        raise https_fn.HttpsError("internal", f"Error: {str(e)}")


@https_fn.on_call()
def get_brand_name(data: https_fn.CallableRequest) -> str:
    try:
        # Extract the brand and model IDs from the request data.
        brand_id = data.data

        if not brand_id:
            raise ValueError("Missing brandId")

        # Initialize Firestore client
        db = firestore.client()

        # Reference the document: all_brands/{brand_id}
        doc_ref = db.collection("all_brands").document(brand_id)
        doc = doc_ref.get()

        # Return the brand name if it exists
        if doc.exists:
            doc_data = doc.to_dict()
            return doc_data.get("name", "")
        else:
            return ""

    except Exception as e:
        # Return a structured HTTPS error
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.INTERNAL, message=str(e))
