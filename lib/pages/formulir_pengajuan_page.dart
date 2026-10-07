import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/pengajuan_model.dart';

class FormulirPengajuanPage extends StatefulWidget {
  const FormulirPengajuanPage({super.key});

  @override
  State<FormulirPengajuanPage> createState() => _FormulirPengajuanPageState();
}

class _FormulirPengajuanPageState extends State<FormulirPengajuanPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController catatanController = TextEditingController();

  String bidangTerpilih = 'Kependudukan';
  String? sesiTerpilih;
  bool setujuDataPribadi = false;
  bool sedangMengirim = false;

  final List<String> daftarBidang = const [
    'Kependudukan',
    'Perizinan',
    'Sosial',
  ];

  final List<String> daftarSesi = const [
    'Pagi',
    'Siang',
    'Sore',
  ];

  bool get emailValid => emailController.text.trim().contains('@');

  bool get formLengkap =>
      namaController.text.trim().isNotEmpty &&
      emailController.text.trim().isNotEmpty &&
      emailValid &&
      setujuDataPribadi &&
      sesiTerpilih != null;

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    catatanController.dispose();
    super.dispose();
  }

  Future<void> kirimPengajuan() async {
    setState(() => sedangMengirim = true);

    // Simulasi pengiriman data asinkron selama 2 detik sesuai ketentuan modul
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final pengajuanBaru = Pengajuan(
      id: 'REQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      nama: namaController.text.trim(),
      email: emailController.text.trim(),
      bidang: bidangTerpilih,
      sesi: sesiTerpilih!,
      tanggal: DateTime.now(),
      deskripsi: catatanController.text.trim().isNotEmpty
          ? catatanController.text.trim()
          : 'Pengajuan Layanan $bidangTerpilih',
      selesai: false,
    );

    context.read<PengajuanModel>().tambah(pengajuanBaru);

    setState(() => sedangMengirim = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pengajuan atas nama ${pengajuanBaru.nama} berhasil dikirim!'),
        backgroundColor: Colors.teal.shade700,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Pengajuan Layanan'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              color: Colors.teal.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.teal, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Layanan Warga Terpadu Nusantara Cerdas. Isi data diri Anda dengan benar untuk diproses petugas.',
                        style: TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bidang Layanan Dropdown
            DropdownButtonFormField<String>(
              initialValue: bidangTerpilih,
              decoration: const InputDecoration(
                labelText: 'Bidang Layanan',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: daftarBidang.map((bidang) {
                return DropdownMenuItem(
                  value: bidang,
                  child: Text(bidang),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => bidangTerpilih = val);
              },
            ),
            const SizedBox(height: 14),

            // Nama Lengkap
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                hintText: 'Contoh: Ghazy Nabil Alghfari',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 14),

            // Email dengan validasi '@'
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'alghifarighazy508@gmail.com',
                prefixIcon: const Icon(Icons.email),
                border: const OutlineInputBorder(),
                errorText: emailController.text.isNotEmpty && !emailValid
                    ? 'Email wajib mengandung karakter "@"'
                    : null,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 14),

            // Catatan / Deskripsi Permohonan
            TextField(
              controller: catatanController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Deskripsi / Catatan Permohonan',
                hintText: 'Tuliskan detail permohonan layanan...',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 14),

            // Checkbox Persetujuan Data Pribadi
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: setujuDataPribadi,
              title: const Text(
                'Saya menyetujui pemrosesan data pribadi untuk keperluan verifikasi dinas',
                style: TextStyle(fontSize: 13),
              ),
              onChanged: (nilai) {
                setState(() => setujuDataPribadi = nilai ?? false);
              },
            ),
            const SizedBox(height: 8),

            const Text(
              'Pilih Sesi Kunjungan Layanan:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),

            // Radio Button Sesi Kunjungan (sesuai spesifikasi modul menggunakan RadioListTile groupValue)
            ...daftarSesi.map((sesi) {
              // ignore: deprecated_member_use
              return RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                title: Text('Sesi $sesi'),
                subtitle: Text(
                  sesi == 'Pagi'
                      ? 'Pukul 08.00 - 11.30 WIB'
                      : sesi == 'Siang'
                          ? 'Pukul 13.00 - 15.00 WIB'
                          : 'Pukul 15.30 - 17.00 WIB',
                  style: const TextStyle(fontSize: 12),
                ),
                value: sesi,
                // ignore: deprecated_member_use
                groupValue: sesiTerpilih,
                // ignore: deprecated_member_use
                onChanged: (nilai) {
                  setState(() => sesiTerpilih = nilai);
                },
              );
            }),

            const SizedBox(height: 20),

            // Tombol Kirim Pengajuan
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: (formLengkap && !sedangMengirim) ? kirimPengajuan : null,
              child: sedangMengirim
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'Kirim Pengajuan',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
