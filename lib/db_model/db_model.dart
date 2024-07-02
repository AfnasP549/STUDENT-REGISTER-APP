class StudentModel {
  int? id;
  late String name;
  String? age;
  String? domain;
  String? contact;
  String? imagePath; 

  StudentModel({
    this.id,
    required this.name,
    required this.age,
    required this.domain,
    required this.contact,
    required this.imagePath,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'domain': domain,
      'contact': contact,
      'imagePath': imagePath,
    };
  }

  static StudentModel fromMap(Map<String, Object?> map) {
    final id = map['id'] as int;
    final name = map['name'] as String;
    final age = map['age'] as String;
    final domain = map['domain'] as String?;
    final contact = map['contact'] as String?;
    final imagePath = map['imagePath'] as String?;

    return StudentModel(
      id: id,
      name: name,
      age: age,
      domain: domain,
      contact: contact,
      imagePath: imagePath,
    );
  }
}
