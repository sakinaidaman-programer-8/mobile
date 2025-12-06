class Booking {
  final String id;
  final String nmPasien;
  final String tglBooking;

  Booking({
    required this.id,
    required this.nmPasien,
    required this.tglBooking,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'].toString(),
      nmPasien: json['nm_pasien'] ?? 'Nama tidak ada',
      tglBooking: json['tgl_booking'] ?? '',
    );
  }
}
