import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/pengajuan_model.dart';
import '../navigation/app_routes.dart';

class WargaPage extends StatelessWidget {
  const WargaPage({super.key});

  void _tampilkanRincian(BuildContext context, Pengajuan p) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              p.selesai ? Icons.check_circle : Icons.pending,
              color: p.selesai ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 8),
            const Text('Rincian Pengajuan', style: TextStyle(fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _barisInfo('Nomor ID', p.id),
            _barisInfo('Nama Lengkap', p.nama),
            _barisInfo('Email Warga', p.email),
            _barisInfo('Bidang Layanan', p.bidang),
            _barisInfo('Sesi Kunjungan', 'Sesi ${p.sesi}'),
            _barisInfo(
              'Status Tindak Lanjut',
              p.selesai ? 'Selesai Ditindaklanjuti' : 'Sedang Diproses Dinas',
            ),
            const SizedBox(height: 8),
            const Text(
              'Deskripsi Permohonan:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              p.deskripsi,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _barisInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<PengajuanModel>();
    final daftar = model.daftarPengajuan;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_pengajuan_baru',
        // Menggunakan named route sesuai instruksi modul
        onPressed: () => Navigator.pushNamed(context, AppRoutes.formulirPengajuan),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Pengajuan Baru'),
        tooltip: 'Buka formulir pengajuan baru',
      ),
      body: daftar.isEmpty
          ? const Center(
              child: Text('Belum ada riwayat pengajuan layanan.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              itemCount: daftar.length,
              itemBuilder: (context, index) {
                final p = daftar[index];
                return GestureDetector(
                  // onTap: Membuka rincian pengajuan
                  onTap: () => _tampilkanRincian(context, p),
                  // onLongPress: Menandai pengajuan sebagai selesai ditindaklanjuti
                  onLongPress: () {
                    if (!p.selesai) {
                      context.read<PengajuanModel>().tandaiSelesai(p.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Pengajuan ${p.id} (${p.nama}) ditandai SELESAI ditindaklanjuti.',
                          ),
                          backgroundColor: Colors.green.shade700,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Pengajuan ${p.id} sudah berstatus selesai.',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: p.selesai ? Colors.green.shade300 : Colors.teal.shade100,
                        width: 1.2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  p.id,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal.shade800,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: p.selesai
                                      ? Colors.green.shade50
                                      : Colors.amber.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: p.selesai
                                        ? Colors.green.shade600
                                        : Colors.amber.shade700,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      p.selesai
                                          ? Icons.check_circle_outline
                                          : Icons.hourglass_top,
                                      size: 14,
                                      color: p.selesai
                                          ? Colors.green.shade700
                                          : Colors.amber.shade800,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      p.selesai ? 'Selesai' : 'Dalam Proses',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: p.selesai
                                            ? Colors.green.shade800
                                            : Colors.amber.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            p.nama,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            p.deskripsi,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const Divider(height: 18),
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.category_outlined,
                                      size: 14, color: Colors.teal),
                                  const SizedBox(width: 4),
                                  Text(
                                    p.bidang,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.access_time,
                                      size: 14, color: Colors.teal),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Sesi ${p.sesi}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                'Tahan utk selesai',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
