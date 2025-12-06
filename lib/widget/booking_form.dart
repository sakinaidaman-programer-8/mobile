import 'package:apk_poli/theme/flash_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:string_similarity/string_similarity.dart';
import '../model/dokter_jadwal.dart';
import '../services/booking_service.dart';
import '../provider/poli_provider.dart';
import '../provider/dokter_jadwal_provider.dart';
import '../provider/histori_provider.dart';
import '../model/data_pasien.dart';
import '../theme/app_colors.dart';

class BookingFormPage extends StatefulWidget {
  final DataPasien dataPasien;

  const BookingFormPage({super.key, required this.dataPasien});

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController namaC;
  late TextEditingController alamatC;
  late TextEditingController telpC;
  late TextEditingController tglBookingC;
  late TextEditingController keluhanC;
  late TextEditingController jenisKelaminC;
  late TextEditingController nikC;
  late TextEditingController emailC;
  late TextEditingController idKawinC;
  late TextEditingController tglLahirC;

  String? selectedPoliId;
  String? selectedPoliNama;
  String? selectedDokterId;

  bool _isSubmitting = false;
  final BookingService _bookingService = BookingService();

  @override
  void initState() {
    super.initState();
    namaC = TextEditingController(text: widget.dataPasien.nama);
    alamatC = TextEditingController(text: widget.dataPasien.alamat ?? "");
    telpC = TextEditingController(text: widget.dataPasien.noTelp ?? "");
    tglBookingC = TextEditingController(text: "");
    keluhanC = TextEditingController();

    jenisKelaminC = TextEditingController(text: widget.dataPasien.jenisKelamin);
    nikC = TextEditingController(text: widget.dataPasien.noIdentitas);
    emailC = TextEditingController(text: widget.dataPasien.email ?? "");
    idKawinC = TextEditingController(text: widget.dataPasien.idKawin ?? "");
    tglLahirC = TextEditingController(text: widget.dataPasien.tglLahir ?? "");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    try {
      await Provider.of<PoliProvider>(context, listen: false).fetchPoli();
      await Provider.of<DokterJadwalProvider>(context, listen: false).fetchJadwal();
    } catch (e) {
      if (mounted) {
        showFlashSnackBar(context,"Gagal memuat data: $e");
      }
    }
  }

  @override
  void dispose() {
    namaC.dispose();
    alamatC.dispose();
    telpC.dispose();
    tglBookingC.dispose();
    keluhanC.dispose();
    jenisKelaminC.dispose();
    nikC.dispose();
    emailC.dispose();
    idKawinC.dispose();
    tglLahirC.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller,
      {DateTime? firstDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: firstDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (picked != null && mounted) {
      setState(() {
        controller.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedPoliId == null || selectedDokterId == null) {
      showFlashSnackBar(context,"Pilih poli dan dokter terlebih dahulu");
      return;
    }

    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    final body = {
      "nama": namaC.text.trim(),
      "alamat": alamatC.text.trim(),
      "rm": "",
      "no_telp": telpC.text.trim(),
      "jenis_kelamin": jenisKelaminC.text.trim(),
      "no_identitas": nikC.text.trim(),
      "id_kawin": idKawinC.text.trim(),
      "tgl_lahir": tglLahirC.text.trim(),
      "email": emailC.text.trim(),
      "id_unit": selectedPoliId,
      "id_layanan": selectedPoliId,
      "id_dokter": selectedDokterId,
      "keterangan": keluhanC.text.trim(),
      "tgl_booking": tglBookingC.text.trim(),
    };

    try {
      final res = await _bookingService.createBookingMobile(
        body,
        widget.dataPasien.token ?? "",
      );

      if (!mounted) return;

      if (res['status'] == 'success') {
        final noAntrian = res['data']['no_antrian']?.toString() ?? "-";
        final newBooking = {
          'booking_id': res['data']['booking_id'] ?? "-",
          'no_antrian': noAntrian,
          'tgl_booking': res['data']['tgl_booking'] ?? "",
          'rm': widget.dataPasien.rm,
          'no_identitas': widget.dataPasien.noIdentitas,
          'nama_pasien': widget.dataPasien.nama,
          'poli': selectedPoliNama,
        };

        final historyProv = Provider.of<HistoryProvider>(context, listen: false);
        historyProv.addBooking(newBooking);

        await showDialog(
          context: context,
          builder: (_) => Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:AppColors.background,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.blue.shade600, size: 60),
                  const SizedBox(height: 12),
                  const Text(
                    "Booking Berhasil!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow("Nomor Booking:", res['data']['booking_id']?.toString() ?? "-"),
                  // const SizedBox(height: 8),
                  // _buildInfoRow("Nomor Antrian:", res['data']['no_antrian']?.toString() ?? "-"),
                  const SizedBox(height: 8),
                  if (res['data']['estimasi_waktu'] != null)
                    _buildInfoRow("Estimasi Waktu:", res['data']['estimasi_waktu']),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("OK",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? 'Gagal melakukan booking')),
        ); 
      }
    } catch (e, stack) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Terjadi error saat booking: $e")),
        );
      }
      if (kDebugMode) {
        print("ERROR SUBMIT BOOKING:");
        print(e);
        debugPrintStack(stackTrace: stack);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final poliProv = Provider.of<PoliProvider>(context);
    final dokterProv = Provider.of<DokterJadwalProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Pendaftaran Antrian", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade600,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 16),
        child: poliProv.loading
            ? _buildModernLoading()
            : Column(
                children: [
                  // Info Pasien Card
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 6,
                    shadowColor: Colors.blue.shade200,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade400, Colors.blue.shade200],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.person, size: 30, color: Colors.blue.shade400),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  widget.dataPasien.nama,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.home, color: Colors.white70, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.dataPasien.alamat ?? "-",
                                  style: const TextStyle(fontSize: 16, color:AppColors.textDark),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.phone, color: Colors.white70, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                widget.dataPasien.noTelp ?? "-",
                                style: const TextStyle(fontSize: 16, color:AppColors.textDark),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Form Booking
                  Expanded(
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: ListView(
                        children: [
                          _buildModernTextField(
                            tglBookingC,
                            "Tanggal Booking",
                            Icons.calendar_today,
                            readOnly: true,
                            onTap: () => _selectDate(context, tglBookingC, firstDate: DateTime.now()),
                          ),
                          const SizedBox(height: 16),
                          _buildDropdownPoli(poliProv),
                          const SizedBox(height: 16),
                          _buildDropdownDokter(poliProv, dokterProv),
                          const SizedBox(height: 16),
                          _buildModernTextField(keluhanC, "Keluhan", Icons.notes, maxLines: 3),
                          const SizedBox(height: 32),
                          _buildSubmitButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Modern TextField
  Widget _buildModernTextField(TextEditingController controller,String label,IconData icon, {
    int maxLines = 1,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        keyboardType: keyboardType,
        validator: validator,
        onTap: onTap,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blue.shade600, fontWeight: FontWeight.w600),
          prefixIcon: Icon(icon, color: Colors.blue.shade600),
          filled: true,
          fillColor: AppColors.background,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownPoli(PoliProvider poliProv) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonFormField<String>(
        value: selectedPoliId,
        decoration: InputDecoration(
          labelText: "Pilih Poli",
          labelStyle: TextStyle(color: Colors.blue.shade600, fontWeight: FontWeight.w600),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
        style: const TextStyle(color: Colors.black, fontSize: 16),
        dropdownColor: AppColors.background, 
        items: poliProv.poliList.map((p) => DropdownMenuItem(
          value: p.id.toString(),
          child: Text(
            p.namaLayanan,
            style: const TextStyle(fontSize: 16),
          ),
        )).toList(),
        onChanged: (v) {
          if (v != null) {
            final poli = poliProv.poliList.firstWhere(
              (p) => p.id.toString() == v,
              orElse: () => poliProv.poliList.first,
            );
            setState(() {
              selectedPoliId = v;
              selectedPoliNama = poli.namaLayanan;
              selectedDokterId = null;
            });
          }
        },
        validator: (v) => v == null ? "Pilih poli terlebih dahulu" : null,
        icon: Icon(Icons.keyboard_arrow_down, color: const Color.fromRGBO(30, 136, 229, 1)),
        isExpanded: true,
      ),
    );
  }

  Widget _buildModernLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.staggeredDotsWave(color: Colors.blue.shade600, size: 50),
          // const SizedBox(height: 16),
          // const Text(
          //   "Memuat data...",
          //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
          // ),
        ],
      ),
    );
  }

  Widget _buildDropdownDokter(PoliProvider poliProv, DokterJadwalProvider dokterProv) {
    if (selectedPoliId == null) return const SizedBox.shrink();

    final selectedPoli = poliProv.poliList.firstWhere((p) => p.id.toString() == selectedPoliId);
    final namaPoliDipilih = selectedPoli.namaLayanan;

    final filteredDokter = dokterProv.jadwals.where((d) {
      final similarity = d.namaPoli.similarityTo(namaPoliDipilih);
      return similarity > 0.6;
    }).toList();

    final filteredDokterUnique = filteredDokter.fold<List<DokterJadwal>>([], (prev, element) {
      if (!prev.any((d) => d.dokterId == element.dokterId)) prev.add(element);
      return prev;
    });

    if (filteredDokterUnique.isEmpty) {
      return const Text(
        "Dokter untuk poli ini belum tersedia",
        style: TextStyle(fontSize: 14, color: Colors.black54),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonFormField<String>(
            value: filteredDokterUnique.any((d) => d.dokterId == selectedDokterId)
                ? selectedDokterId
                : null,
            decoration: InputDecoration(
              labelText: "Pilih Dokter",
              labelStyle: TextStyle(color: Colors.blue.shade600, fontWeight: FontWeight.w600),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
            style: const TextStyle(color: Colors.black, fontSize: 16),
            dropdownColor: AppColors.background,
            items: filteredDokterUnique
                .map((d) => DropdownMenuItem(
                      value: d.dokterId,
                      child: Text(
                        d.namaDokter,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ))
                .toList(),
            onChanged: (v) => setState(() => selectedDokterId = v),
            validator: (v) => v == null ? "Pilih dokter terlebih dahulu" : null,
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.blue.shade600),
            isExpanded: true,
          ),
        ),
        const SizedBox(height: 8),
        if (selectedDokterId != null)
          Text(
            "Jam praktik: ${filteredDokterUnique.firstWhere((d) => d.dokterId == selectedDokterId).jadwal}",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
          ),
      ],
    );
  }


  Widget _buildSubmitButton() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : submitForm,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF2196F3), Color(0xFF64B5F6)]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: _isSubmitting
                ? LoadingAnimationWidget.staggeredDotsWave(color: AppColors.background, size: 25)
                : const Text(
                    "Daftar Sekarang",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.background),
                  ),
          ),
        ),
      ),
    );
  }
}
