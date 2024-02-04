class RoutineModel {
  final int id;
  final String name, type;
  bool isActived, isClicked;
  final List<String> routineTags;
  final DateTime? activedAt, inactivedAt;
  final List<dynamic> datetime;
  final int? goal;

  RoutineModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        type = json['type'],
        datetime = json['datetime'],
        isActived = json['isActived'],
        routineTags = json['routineTags'].cast<String>(),
        activedAt = json['activedAt'] != null
            ? DateTime.parse(json['activedAt'])
            : null,
        inactivedAt = json['inactivedAt'] != null
            ? DateTime.parse(json['inactivedAt'])
            : null,
        isClicked = false,
        goal = json['goal'];
}
