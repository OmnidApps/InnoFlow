class Usecase {
  final int? id;
  final String name;
  final String description;
  final int? workflowID;

  Usecase({this.id, required this.name, required this.description, this.workflowID});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'workflow_id': workflowID,
    };
  }

  factory Usecase.fromMap(Map<String, dynamic> map) {
    return Usecase(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      workflowID: map['workflow_id'],
    );
  }

  Usecase copyWith({
    int? id,
    String? name,
    String? description,
    int? workflowID,
  }) {
    return Usecase(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      workflowID: workflowID ?? this.workflowID,
    );
  }
}