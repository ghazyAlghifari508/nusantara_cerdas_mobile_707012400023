import 'package:flutter/foundation.dart';

class Pengajuan {
  final String id;
  final String nama;
  final String email;
  final String bidang; // Kependudukan, Perizinan, Sosial
  final String sesi;   // Pagi, Siang, Sore
  final DateTime tanggal;
  final String deskripsi;
  bool selesai;

  Pengajuan({
    required this.id,
    required this.nama,
    required this.email,
    required this.bidang,
    required this.sesi,
    required this.tanggal,
    required this.deskripsi,
    this.selesai = false,
  });
}

class PengajuanModel extends ChangeNotifier {
  final List<Pengajuan> _daftarPengajuan = [
    Pengajuan(
      id: 'REQ-001',
      nama: 'Budi Santoso',
      email: 'budi.santoso@gmail.com',
      bidang: 'Kependudukan',
      sesi: 'Pagi',
      tanggal: DateTime.now().subtract(const Duration(days: 1)),
      deskripsi: 'Permohonan Pencetakan Kartu Tanda Penduduk (KTP) Elektronik Baru',
      selesai: false,
    ),
    Pengajuan(
      id: 'REQ-002',
      nama: 'Siti Aminah',
      email: 'siti.aminah@gmail.com',
      bidang: 'Perizinan',
      sesi: 'Siang',
      tanggal: DateTime.now().subtract(const Duration(hours: 5)),
      deskripsi: 'Pengajuan Izin Usaha Mikro Kecil (IUMK) Toko Kelontong',
      selesai: true,
    ),
    Pengajuan(
      id: 'REQ-003',
      nama: 'Ahmad Fauzi',
      email: 'ahmad.fauzi@gmail.com',
      bidang: 'Sosial',
      sesi: 'Sore',
      tanggal: DateTime.now().subtract(const Duration(hours: 2)),
      deskripsi: 'Verifikasi Data Penerima Bantuan Pangan Non-Tunai Warga',
      selesai: false,
    ),
  ];

  List<Pengajuan> get daftarPengajuan => List.unmodifiable(_daftarPengajuan);

  void tambah(Pengajuan pengajuan) {
    _daftarPengajuan.insert(0, pengajuan);
    notifyListeners();
  }

  void tandaiSelesai(String id) {
    final index = _daftarPengajuan.indexWhere((p) => p.id == id);
    if (index != -1) {
      _daftarPengajuan[index].selesai = true;
      notifyListeners();
    }
  }

  int jumlahBidang(String bidang) {
    return _daftarPengajuan.where((p) => p.bidang.toLowerCase() == bidang.toLowerCase()).length;
  }
}
