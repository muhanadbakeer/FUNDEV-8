class UserProfile {
  int? id;
  String name;
  String email;
  String phone;
  String age;
  String weight;
  String height;

  UserProfile({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.weight,
    required this.height,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as int?,
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      phone: map['phone'] ?? "",
      age: map['age'] ?? "",
      weight: map['weight'] ?? "",
      height: map['height'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'weight': weight,
      'height': height,
    };
  }
}
