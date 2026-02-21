class EventModel {
  const EventModel({required this.id, required this.name, required this.code});

  final String id;
  final String name;
  final String code;

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      code: map['code']?.toString() ?? '',
    );
  }
}
