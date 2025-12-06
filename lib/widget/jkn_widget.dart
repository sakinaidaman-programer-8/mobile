import 'package:apk_poli/model/data_pasien.dart';
import 'package:apk_poli/widget/booking_form.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../theme/app_colors.dart';

class JKNPage extends StatefulWidget {
  final DataPasien dataPasien;
  const JKNPage({super.key, required this.dataPasien});

  @override
  State<JKNPage> createState() => _JKNPageState();
}

class _JKNPageState extends State<JKNPage> with SingleTickerProviderStateMixin {
final _formKey = GlobalKey<FormState>();
final TextEditingController _nikC = TextEditingController(text: "");
final TextEditingController _noBPJSC = TextEditingController(text: "");

  bool _loading = false;
  String? _verifikasiMessage;

  late AnimationController _cardController; 

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      lowerBound: 0,
      upperBound: 8,
    );
  }

  @override
  void dispose() {
    _nikC.dispose();
    _noBPJSC.dispose();
    _cardController.dispose();
    super.dispose();
  }

  Future<void> _verifikasi() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _verifikasiMessage = null;
    });

    _cardController.forward().then((_) => _cardController.reverse());

    await Future.delayed(const Duration(seconds: 2)); // Simulasi API

    if (_nikC.text == '1234567890123456' && _noBPJSC.text == '0001234567890') {
      setState(() {
        _verifikasiMessage = 'Peserta valid!\nNama: John Doe\nStatus: Aktif';
      });

      _showDaftarPilihan();
    } else {
      setState(() {
        _verifikasiMessage = 'Nomor BPJS tidak sesuai dengan NIK.';
      });
    }

    setState(() {
      _loading = false;
    });
  }

  void _showDaftarPilihan() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pilih Jenis Pendaftaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.local_hospital),
              label: Text('Daftar ke Poli'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(context);
                _daftarKe('Poli');
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.account_balance),
              label: Text('Daftar ke FO'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(context);
                _daftarKe('FO');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _daftarKe(String jenis) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Didaftarkan ke $jenis')),
  );

  Future.delayed(const Duration(milliseconds: 500), () {
    if (jenis == 'Poli') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingFormPage(
            dataPasien: widget.dataPasien,
          ),
        ),
      );
      } else if (jenis == 'FO') {
        // Route ke halaman FO
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Verifikasi JKN/BPJS", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade600,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 16),
        child: Column(
          children: [
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
                          child: Icon(Icons.health_and_safety, size: 30, color: Colors.blue.shade400),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            "Verifikasi Pasien JKN/BPJS",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_verifikasiMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _verifikasiMessage!.startsWith('✅')
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _verifikasiMessage!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _verifikasiMessage!.startsWith('✅')
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  children: [
                    _buildModernTextField(_nikC, "NIK", Icons.badge, keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    _buildModernTextField(_noBPJSC, "No. BPJS", Icons.card_membership, keyboardType: TextInputType.number),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _loading ? null : _verifikasi,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _loading
                          ? LoadingAnimationWidget.staggeredDotsWave(color: AppColors.blue2, size: 25)
                          : const Text("Verifikasi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildModernTextField(TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: AppColors.textDark), 
      validator: (value) {
        if (value == null || value.isEmpty) return '$label tidak boleh kosong';
        if (label == 'NIK' && value.length != 16) return 'NIK harus 16 digit';
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue.shade400),
        filled: true,
        fillColor: Colors.blue.shade50,
        hintText: "Masukkan 16 digit NIK",
        hintStyle: TextStyle(color: AppColors.textDark),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.blue.shade400, width: 2)),
      ),
    );
  }
}
