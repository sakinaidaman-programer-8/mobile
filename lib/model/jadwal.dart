class Jadwal {
  final int idDokter;
  final int idLayanan;
  final String kodePoli;
  final String kodeSubspesialis;
  final String namaSubspesialis;
  final String namaDokter;
  final String namaPoli;
  final int createdId;
  final DateTime createdAt;

  Jadwal({
    required this.idDokter,
    required this.idLayanan,
    required this.kodePoli,
    required this.kodeSubspesialis,
    required this.namaSubspesialis,
    required this.namaDokter,
    required this.namaPoli,
    required this.createdId,
    required this.createdAt,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    return Jadwal(
      idDokter: json['id_dokter'],
      idLayanan: json['id_layanan'],
      kodePoli: json['kodepoli'],
      kodeSubspesialis: json['kodesubspesialis'],
      namaSubspesialis: json['namasubspesialis'],
      namaDokter: json['namadokter'],
      namaPoli: json['namapoli'],
      createdId: json['created_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
