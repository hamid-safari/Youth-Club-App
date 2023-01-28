class Event {
  String? id;
  String? adminId;
  String title;
  final int date; //timetsamp

  Event({
    this.id,
    this.adminId,
    required this.title,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "date": date,
        "adminId": adminId,
      };

  Event.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        title = data["title"],
        adminId = data["adminId"],
        date = data["date"];
}
