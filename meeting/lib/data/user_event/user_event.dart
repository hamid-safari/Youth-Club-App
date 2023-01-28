class UserEvent {
  String? id;
  final String userId;
  final String eventId;
  final int date; //timetsamp

  UserEvent({
    this.id,
    required this.userId,
    required this.eventId,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "eventId": eventId,
        "date": date,
      };

  UserEvent.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        userId = data['userId'],
        eventId = data['eventId'],
        date = data['date'];
}
