// class DataPasien {
//   final String rm;
//   final String? rmLama;
//   final String nama;
//   final String jenisKelamin;
//   final String? tempatLahir;
//   final String? alamat;
//   final String? noTelp;
//   final String? email;
//   final String noIdentitas;
//   String? token; // <-- simpan token

//   DataPasien({
//     required this.rm,
//     this.rmLama,
//     required this.nama,
//     required this.jenisKelamin,
//     this.tempatLahir,
//     this.alamat,
//     this.noTelp,
//     this.email,
//     required this.noIdentitas,
//     this.token,
//   });

//   factory DataPasien.fromJson(Map<String, dynamic> json) => DataPasien(
//         rm: json['rm'] ?? '',
//         rmLama: json['rm_lama'],
//         nama: json['nama'] ?? '',
//         jenisKelamin: json['jenis_kelamin'] ?? '',
//         tempatLahir: json['tempat_lahir'],
//         alamat: json['alamat'],
//         noTelp: json['no_telp'],
//         email: json['email'],
//         noIdentitas: json['no_identitas'] ?? '',
//       );

//   Map<String, dynamic> toJson() => {
//         'rm': rm,
//         'rm_lama': rmLama,
//         'nama': nama,
//         'jenis_kelamin': jenisKelamin,
//         'tempat_lahir': tempatLahir,
//         'alamat': alamat,
//         'no_telp': noTelp,
//         'email': email,
//         'no_identitas': noIdentitas,
//       };
// }

class DataPasien {
  final String rm;
  final String? rmLama;
  final String nama;
  final String jenisKelamin;
  final String? tempatLahir;
  final String? alamat;
  final String? noTelp;
  final String? email;
  final String noIdentitas;
  final String? idKawin;
  final String? tglLahir;
  final String? idLayanan;
  final String? idDokter;
  final String? keterangan;
  final String? tglBooking;
  String? token; // <-- simpan token

  DataPasien({
    required this.rm,
    this.rmLama,
    required this.nama,
    required this.jenisKelamin,
    this.tempatLahir,
    this.alamat,
    this.noTelp,
    this.email,
    required this.noIdentitas,
    this.idKawin,
    this.tglLahir,
    this.idLayanan,
    this.idDokter,
    this.keterangan,
    this.tglBooking,
    this.token,
  });

  factory DataPasien.fromJson(Map<String, dynamic> json) {
    // Fungsi helper untuk aman konversi ke String
    String? toStr(dynamic value) => value?.toString();

    return DataPasien(
      rm: toStr(json['rm']) ?? '',
      rmLama: toStr(json['rm_lama']),
      nama: json['nama'] ?? '',
      jenisKelamin: json['jenis_kelamin'] ?? '',
      tempatLahir: toStr(json['tempat_lahir']),
      alamat: toStr(json['alamat']),
      noTelp: toStr(json['no_telp']),
      email: json['email'] ?? '',
      noIdentitas: toStr(json['no_identitas']) ?? '',
      idKawin: toStr(json['id_kawin']),
      tglLahir: toStr(json['tgl_lahir']),
      idLayanan: toStr(json['id_layanan']),
      idDokter: toStr(json['id_dokter']),
      keterangan: toStr(json['keterangan']),
      tglBooking: toStr(json['tgl_booking']),
    );
  }

  Map<String, dynamic> toJson() => {
        'rm': rm,
        'rm_lama': rmLama,
        'nama': nama,
        'jenis_kelamin': jenisKelamin,
        'tempat_lahir': tempatLahir,
        'alamat': alamat,
        'no_telp': noTelp,
        'email': email,
        'no_identitas': noIdentitas,
        'id_kawin': idKawin,
        'tgl_lahir': tglLahir,
        'id_layanan': idLayanan,
        'id_dokter': idDokter,
        'keterangan': keterangan,
        'tgl_booking': tglBooking,
      };
}
