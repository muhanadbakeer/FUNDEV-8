class Doctor {
  final String name;
  final String specialty;
  final String image;
  final String experience;
  final String about;

  final String? phone;
  final String? whatsapp;
  final double? lat;
  final double? lng;

  Doctor({
    required this.name,
    required this.specialty,
    required this.image,
    required this.experience,
    required this.about,

    this.phone,
    this.whatsapp,
    this.lat,
    this.lng,
  });
}
