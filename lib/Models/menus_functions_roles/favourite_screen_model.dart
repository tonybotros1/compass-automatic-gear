class FavouriteScreensModel {
  final String id;
  final String screenName;
  final String routeName;
  final String screenId;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  FavouriteScreensModel({
    required this.id,
    required this.screenName,
    required this.routeName,
    required this.screenId,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FavouriteScreensModel.fromJson(Map<String, dynamic> json) {
    return FavouriteScreensModel(
      id: json['_id'] ?? '',
      screenName: json['screen_name'] ?? '',
      routeName: json['screen_route'] ?? '',
      screenId: json['screen_id'],
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['screen_name'] = screenName;
    data['route_name'] = routeName;
    data['screen_id'] = screenId;
    data['description'] = description;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
