import 'package:flutter/material.dart';

class TanyaPetugasPage extends StatefulWidget {
  const TanyaPetugasPage({super.key});

  @override
  State<TanyaPetugasPage> createState() => _TanyaPetugasPageState();
}

class _TanyaPetugasPageState extends State<TanyaPetugasPage> {
  final TextEditingController pesanController = TextEditingController();

  final List<Map<String, dynamic>> daftarPesan = [
    {
      'teks': 'Halo warga Nusantara! Selamat datang di Layanan Bantuan Diskominfo. Ada yang bisa kami bantu terkait permohonan layanan Anda?',
      'dariSaya': false,
      'waktu': '08:30',
    },
    {
      'teks': 'Selamat pagi petugas, saya ingin menanyakan persyaratan berkas untuk cetak KTP baru di sesi pagi.',
      'dariSaya': true,
      'waktu': '08:35',
    },
    {
      'teks': 'Baik, silakan membawa fotokopi Kartu Keluarga dan surat pengantar RT/RW saat hadir di kantor layanan sesuai sesi.',
      'dariSaya': false,
      'waktu': '08:37',
    },
  ];

  @override
  void dispose() {
    pesanController.dispose();
    super.dispose();
  }

  void kirimPesan() {
    final teks = pesanController.text.trim();
    if (teks.isEmpty) return;

    final now = DateTime.now();
    final waktuFormatted =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      daftarPesan.add({
        'teks': teks,
        'dariSaya': true,
        'waktu': waktuFormatted,
      });
      pesanController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Info Petugas
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Colors.teal.shade50,
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.teal.shade700,
                child: const Icon(Icons.support_agent, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Petugas Helpdesk Diskominfo',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    'Online • Respon cepat dalam jam kerja',
                    style: TextStyle(fontSize: 11, color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Daftar Pesan
        Expanded(
          child: ListView.builder(
            reverse: true,
            padding: const EdgeInsets.all(12),
            itemCount: daftarPesan.length,
            itemBuilder: (context, index) {
              final pesan = daftarPesan[daftarPesan.length - 1 - index];
              final bool dariSaya = pesan['dariSaya'] as bool;

              return Align(
                alignment: dariSaya ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.78,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: dariSaya ? Colors.teal : Colors.grey.shade200,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(14),
                      topRight: const Radius.circular(14),
                      bottomLeft: Radius.circular(dariSaya ? 14 : 2),
                      bottomRight: Radius.circular(dariSaya ? 2 : 14),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        dariSaya ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        pesan['teks'],
                        style: TextStyle(
                          fontSize: 13.5,
                          color: dariSaya ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pesan['waktu'],
                        style: TextStyle(
                          fontSize: 10,
                          color: dariSaya ? Colors.white70 : Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Input Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: pesanController,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => kirimPesan(),
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan ke petugas...',
                      hintStyle: const TextStyle(fontSize: 13),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.teal,
                  radius: 22,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: kirimPesan,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
