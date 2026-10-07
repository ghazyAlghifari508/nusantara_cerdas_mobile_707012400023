import 'package:flutter/material.dart';
import '../pages/formulir_pengajuan_page.dart';
import 'kerangka_navigasi.dart';

class AppRoutes {
  static const String beranda = '/';
  static const String formulirPengajuan = '/formulir-pengajuan';

  static Map<String, WidgetBuilder> daftarRoute() {
    return {
      beranda: (context) => const KerangkaNavigasi(),
      formulirPengajuan: (context) => const FormulirPengajuanPage(),
    };
  }

  static Route<dynamic>? bentukRoute(RouteSettings settings) {
    return null;
  }

  static Route<dynamic> routeTidakDikenal(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Halaman Tidak Ditemukan')),
        body: Center(
          child: Text('Route ${settings.name} belum terdaftar pada sistem.'),
        ),
      ),
    );
  }
}
