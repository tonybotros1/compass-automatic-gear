class EmployeeAddressModel {
  String? line;
  String? country;
  String? city;
  String? countryName;
  String? cityName;
  String? id;

  EmployeeAddressModel({
    this.line,
    this.country,
    this.city,
    this.countryName,
    this.cityName,
    this.id,
  });

  EmployeeAddressModel.fromJson(Map<String, dynamic> json) {
    line = json.containsKey('line') ? json['line'] ?? '' : '';
    country = json.containsKey('country') ? json['country'] ?? '' : '';
    city = json.containsKey('city') ? json['city'] ?? '' : '';
    countryName = json.containsKey('country_name')
        ? json['country_name'] ?? ''
        : '';
    cityName = json.containsKey('city_name') ? json['city_name'] ?? '' : '';
    id = json.containsKey('_id') ? json['_id'] ?? '' : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['line'] = line;
    data['country'] = country;
    data['city'] = city;
    data['country_name'] = countryName;
    data['city_name'] = cityName;
    data['_id'] = id;
    return data;
  }
}
