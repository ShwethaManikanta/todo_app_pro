class TaskModel {
  final String id;
  final String title;
  final String description;
  final String ownerId;
  final List<String> sharedWith;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.ownerId,
    required this.sharedWith,
  });

  TaskModel copyWith({
    String? title,
    String? description,
    List<String>? sharedWith,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      ownerId: ownerId,
      sharedWith: sharedWith ?? this.sharedWith,
    );
  }
}
