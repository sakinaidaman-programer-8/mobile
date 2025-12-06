class DokterJadwal {
  final String id;
  final String dokterId;
  final String namaDokter;
  final String namaPoli;
  final String? namaSubspesialis;
  final String jadwal;
  final String? status;
  final String? email;
  final String? foto;

  DokterJadwal({
    required this.id,
    required this.dokterId,
    required this.namaDokter,
    required this.namaPoli,
    this.namaSubspesialis,
    required this.jadwal,
    this.status,
    this.email,
    this.foto,
  });

  factory DokterJadwal.fromJson(Map<String, dynamic> json) {
    return DokterJadwal(
      id: json['id'],
      dokterId: json['dokter_id'],
      namaDokter: json['namadokter'],
      namaPoli: json['namapoli'],
      namaSubspesialis: json['namasubspesialis'] ?? '-',
      status: json['status'] ?? '-',
      email: json['email'] ?? '-',
      jadwal: json['jadwal'],
    );
  }
}
