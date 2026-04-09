class HolidayEntry {
  const HolidayEntry({required this.date, required this.name, this.id});

  final DateTime? date;
  final String? name;
  final String? id;

  factory HolidayEntry.fromJson(Map<String, dynamic> json) {
    return HolidayEntry(
      id: json.containsKey('_id') ? json['_id'] ?? '' : '',
      name: json.containsKey('name') ? json['name'] ?? '' : '',
      date: json.containsKey('date')
          ? json['date'] != null
                ? DateTime.tryParse(json['date'])
                : null
          : null,
    );
  }
}
