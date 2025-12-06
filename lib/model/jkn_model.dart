class JknModel {
  final String kode;
  final String title;
  int badge; 

  JknModel({
    required this.kode,
    required this.title,
    this.badge = 0,
  });

  factory JknModel.fromJson(Map<String, dynamic> json) {
    return JknModel(
      kode: json['fs_kd_layanan_bpjs'],
      title: json['fs_nm_layanan_bpjs'],
    );
  }
}
