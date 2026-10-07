import 'package:flutter_test/flutter_test.dart';
import 'package:nusantara_cerdas_mobile_707012400023/model/pengajuan_model.dart';
import 'package:nusantara_cerdas_mobile_707012400023/main.dart';

void main() {
  group('PengajuanModel Unit Tests', () {
    test('Inisialisasi awal PengajuanModel memiliki 3 data riwayat', () {
      final model = PengajuanModel();
      expect(model.daftarPengajuan.length, 3);
      expect(model.jumlahBidang('Kependudukan'), 1);
      expect(model.jumlahBidang('Perizinan'), 1);
      expect(model.jumlahBidang('Sosial'), 1);
    });

    test('Penambahan pengajuan baru berhasil menambah list dan jumlah bidang', () {
      final model = PengajuanModel();
      final baru = Pengajuan(
        id: 'REQ-TEST',
        nama: 'Ghazy Nabil Alghfari',
        email: 'alghifarighazy508@gmail.com',
        bidang: 'Kependudukan',
        sesi: 'Pagi',
        tanggal: DateTime.now(),
        deskripsi: 'Permohonan KTP Elektronik Baru',
      );

      model.tambah(baru);
      expect(model.daftarPengajuan.length, 4);
      expect(model.daftarPengajuan.first.nama, 'Ghazy Nabil Alghfari');
      expect(model.jumlahBidang('Kependudukan'), 2);
    });

    test('Tandai selesai mengubah status pengajuan menjadi selesai', () {
      final model = PengajuanModel();
      expect(model.daftarPengajuan.first.selesai, false);

      model.tandaiSelesai('REQ-001');
      final target = model.daftarPengajuan.firstWhere((p) => p.id == 'REQ-001');
      expect(target.selesai, true);
    });
  });

  group('Widget Tests', () {
    testWidgets('Smoke test render NusantaraCerdasApp', (WidgetTester tester) async {
      await tester.pumpWidget(const NusantaraCerdasApp());
      expect(find.text('Layanan Warga'), findsOneWidget);
    });
  });
}
