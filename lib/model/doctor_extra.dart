class DoctorExtra {
  final String phone;
  final String address;
  final String clinicName;
  final String details;
  final double? lat;
  final double? lng;

  DoctorExtra({
    required this.phone,
    required this.address,
    required this.clinicName,
    required this.details,
    this.lat,
    this.lng,
  });
}

