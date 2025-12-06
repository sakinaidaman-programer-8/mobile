class Poli {
  final int id;
  final String namaLayanan;
  final String fsKdLayanan;
  final String idDokter;

  Poli({
    required this.id,
    required this.namaLayanan,
    required this.fsKdLayanan,
    required this.idDokter,
  });

   factory Poli.fromJson(Map<String, dynamic> json) {
    return Poli(
      id: json['id'] ?? 0,
      namaLayanan: json['namaLayanan'] ?? '',
      fsKdLayanan: json['fs_kd_layanan'] ?? '',
      idDokter: json['id_dokter'] ?? '',
    );
  }
}
