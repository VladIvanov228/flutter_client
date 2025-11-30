

class Company {

  late int id;
  late String name;

  Company({required this.id, required this.name});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
        id: int.parse(json['ogrn'].toString()),
        name: json['name'],
    );
  }
}