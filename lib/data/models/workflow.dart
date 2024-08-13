class Workflow {
  final int? id;
  final String name;
  final String? description;
  final String externalID;

  Workflow({this.id, required this.name, required this.description, required this.externalID});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'external_id': externalID,
    };
  }

  factory Workflow.fromMap(Map<String, dynamic> map) {
    return Workflow(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      externalID: map['external_id'],
    );
  }

  Workflow copyWith({
    int? id,
    String? name,
    String? description,
    String? externalID,
  }) {
    return Workflow(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      externalID: externalID ?? this.externalID,
    );
  }
}