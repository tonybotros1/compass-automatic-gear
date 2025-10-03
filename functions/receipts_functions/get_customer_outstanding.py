from google.cloud import firestore
# import https_fn  # تأكد من استيراد مكتبة Cloud Functions المناسبة
from google.cloud.firestore_v1 import FieldFilter
from google.cloud.firestore_v1.aggregation import AggregationQuery
from firebase_functions import https_fn
from firebase_admin import firestore
from google.cloud.firestore_v1.base_query import FieldFilter
from receipts_functions.calculate_net import calculate_all_nets
from receipts_functions.get_receipt_total import get_total_amount_for_job
# from google.cloud.firestore_v1 import AggregateField


@https_fn.on_call()
def calculate_customer_outstanding(data: https_fn.CallableRequest) -> dict:
    try:
        customer_id = data.data
        if not customer_id:
            raise ValueError("Missing customerId")

        db = firestore.client()
        jobs_ref = db.collection('job_cards').where(
            filter=FieldFilter('customer', '==', customer_id)
        ).where(filter=FieldFilter('job_status_1', '==', 'Posted'))
        jobs = jobs_ref.stream()
        total_outstanding = 0.0
        for job in jobs:
            job_id = job.id
            job_data = job.to_dict()
            # calculate_all_nets(job_id)
            invoice_amount = job_data.get('total_net_amount', 0)
            receipts_amount = get_total_amount_for_job(job_id)
            outstanding = invoice_amount - receipts_amount
            total_outstanding += outstanding

        return total_outstanding

    except Exception as e:
        raise https_fn.HttpsError("internal", f"Error: {str(e)}")


# @https_fn.on_call()
# def calculate_customer_outstanding2(data: https_fn.CallableRequest) -> dict:
#     try:
#         customer_id = data.data
#         if not customer_id:
#             raise ValueError("Missing customerId")

#         db = firestore.client()

#         # استعلام كل job_cards للعميل بالحالة 'Posted'
#         jobs_query = db.collection('job_cards').where(
#             filter=FieldFilter('customer', '==', customer_id)
#         ).where(filter=FieldFilter('job_status_1', '==', 'Posted'))
#         jobs = jobs_query.stream()

#         total_outstanding = 0.0

#         for job in jobs:
#             job_id = job.id
#             print(job_id)
#             print('===============================================================')

#             # ١) جمع قيم 'net' من invoice_items (Server‑Side Aggregation)
#             items_query = db.collection('job_cards') \
#                             .document(job_id) \
#                             .collection('invoice_items')
#             agg_items = AggregationQuery(items_query)
#             agg_items.sum('net', alias='sum_net')
#             items_result = agg_items.get()  # قائمة النتائج
#             print(items_result)
#             sum_net = items_result[0][0].value or 0.0

#             # ٢) جمع مبالغ الإيصالات (receipts) المرتبطة بـ job_id
#             receipts_query = db.collection('all_receipts') \
#                                .where('job_ids', 'array_contains', job_id)
#             agg_receipts = AggregationQuery(receipts_query)
#             agg_receipts.sum(f'jobs.{job_id}', alias='sum_receipts')
#             receipts_result = agg_receipts.get()
#             sum_receipts = receipts_result[0][0].value or 0.0

#             # ٣) حساب المتبقي لكل job
#             outstanding = sum_net - sum_receipts
#             total_outstanding += outstanding

#         return {'totalOutstanding': total_outstanding}

#     except Exception as e:
#         raise https_fn.HttpsError('internal', f'Error: {str(e)}')


# @https_fn.on_call()
# def calculate_customer_outstanding2(data: https_fn.CallableRequest) -> dict:
#     try:
#         customer_id = data.data
#         if not customer_id:
#             raise https_fn.HttpsError(
#                 'invalid-argument',
#                 "Missing customer ID. Please provide a 'customerId' in the request."
#             )

#         db = firestore.client()
#         total_outstanding_amount = 0.0

#         job_cards_query = db.collection('job_cards').where(
#             filter=FieldFilter('customer', '==', customer_id)
#         ).where(filter=FieldFilter('job_status_1', '==', 'Posted'))

#         posted_job_cards = job_cards_query.stream()

#         for job_card in posted_job_cards:
#             job_card_id = job_card.id
#             print(f"Processing Job Card ID: {job_card_id}")

#             invoice_items_ref = db.collection('job_cards').document(
#                 job_card_id).collection('invoice_items')
#             agg_invoice_items = AggregationQuery(invoice_items_ref)
#             agg_invoice_items.sum('net', alias='sum_net_amount')
#             invoice_items_aggregation_result = agg_invoice_items.get()

#             sum_net_from_invoices = invoice_items_aggregation_result[0][0].value or 0.0

#             receipts_query = db.collection('all_receipts').where(
#                 'job_ids', 'array_contains', job_card_id
#             )
#             agg_receipts = AggregationQuery(receipts_query)
#             agg_receipts.sum(f'jobs.{job_card_id}', alias='sum_receipt_amount')
#             receipts_aggregation_result = agg_receipts.get()

#             sum_receipts_for_job = receipts_aggregation_result[0][0].value or 0.0

#             job_card_outstanding = sum_net_from_invoices - sum_receipts_for_job
#             total_outstanding_amount += job_card_outstanding

#         return {'totalOutstanding': total_outstanding_amount}

#     except https_fn.HttpsError as e:
#         raise e
#     except Exception as e:
#         print(f"An unexpected error occurred: {e}")
#         raise https_fn.HttpsError(
#             'internal',
#             f'An unexpected error occurred while calculating outstanding amount: {str(e)}'
#         )
