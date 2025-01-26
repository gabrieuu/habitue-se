class CustomNotification {
  int id;
  String title;
  String description;
  String? payload;

  CustomNotification(
      {required this.id,
      required this.title,
      required this.description,
      this.payload});
}
