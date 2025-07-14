class NotificationModel {
  final String title;
  final String content;
  final String date;

  NotificationModel({
    required this.title,
    required this.content,
    required this.date,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        title: json['title'] ?? '',
        content: json['content'] ?? '',
        date: json['date'] ?? '',
      );

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'date': date,
  };

  NotificationModel copyWith({String? title, String? content, String? date}) {
    return NotificationModel(
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
    );
  }
}
