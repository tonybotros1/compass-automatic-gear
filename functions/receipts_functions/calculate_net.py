from firebase_admin import firestore


def calculate_all_nets(job_id: str) -> float:
    db = firestore.client()
    sum_net = 0.0
    items_ref = db.collection('job_cards').document(
        job_id).collection('invoice_items'
                           )
    items = items_ref.stream()
    for item in items:
        item_data = item.to_dict()
        net_value = item_data.get('net', 0)
        try:
            sum_net += float(net_value)
        except (TypeError, ValueError):
            continue
    return sum_net
