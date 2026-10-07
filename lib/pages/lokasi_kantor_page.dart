import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LokasiKantorPage extends StatefulWidget {
  const LokasiKantorPage({super.key});

  @override
  State<LokasiKantorPage> createState() => _LokasiKantorPageState();
}

class _LokasiKantorPageState extends State<LokasiKantorPage> {
  static const LatLng pusatPeta = LatLng(-6.974001, 107.630348); // Telkom University & Balai Kota
  late GoogleMapController _controller;

  String kantorTerpilih = 'Balai Kota Nusantara Cerdas';
  String alamatTerpilih = 'Jl. Telekomunikasi No. 1, Terusan Buahbatu, Bandung';

  final Set<Marker> markers = {
    const Marker(
      markerId: MarkerId('balai_kota'),
      position: LatLng(-6.974001, 107.630348),
      infoWindow: InfoWindow(
        title: 'Balai Kota Nusantara Cerdas',
        snippet: 'Pusat Pemerintahan & Layanan Terpadu',
      ),
    ),
    const Marker(
      markerId: MarkerId('diskominfo'),
      position: LatLng(-6.970500, 107.633800),
      infoWindow: InfoWindow(
        title: 'Kantor Diskominfo Wilayah Timur',
        snippet: 'Layanan Digital, Sertifikasi & Aduan Siber',
      ),
    ),
    const Marker(
      markerId: MarkerId('ptsp'),
      position: LatLng(-6.977200, 107.627500),
      infoWindow: InfoWindow(
        title: 'Kantor PTSP Pelayanan Terpadu',
        snippet: 'Layanan Perizinan Berusaha & Administrasi Kependudukan',
      ),
    ),
  };

  void _pindahKeLokasi(LatLng posisi, String nama, String alamat) {
    setState(() {
      kantorTerpilih = nama;
      alamatTerpilih = alamat;
    });
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: posisi, zoom: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Google Maps View
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: pusatPeta,
            zoom: 15.2,
          ),
          markers: markers,
          mapType: MapType.normal,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: true,
          onMapCreated: (controller) {
            _controller = controller;
          },
        ),

        // Info Card di bagian atas
        Positioned(
          top: 14,
          left: 14,
          right: 14,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.location_city, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          kantorTerpilih,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          alamatTerpilih,
                          style: const TextStyle(fontSize: 11.5, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Chips Pemilih Lokasi Cepat di bagian bawah
        Positioned(
          bottom: 16,
          left: 12,
          right: 12,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildQuickChip(
                  'Balai Kota (Pusat)',
                  const LatLng(-6.974001, 107.630348),
                  'Balai Kota Nusantara Cerdas',
                  'Jl. Telekomunikasi No. 1, Terusan Buahbatu',
                ),
                const SizedBox(width: 8),
                _buildQuickChip(
                  'Diskominfo Timur',
                  const LatLng(-6.970500, 107.633800),
                  'Kantor Diskominfo Wilayah Timur',
                  'Jl. Radio No. 12, Sukapura, Bandung',
                ),
                const SizedBox(width: 8),
                _buildQuickChip(
                  'Kantor PTSP',
                  const LatLng(-6.977200, 107.627500),
                  'Kantor PTSP Pelayanan Terpadu',
                  'Jl. Sukabirus No. 45, Dayeuhkolot, Bandung',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickChip(String label, LatLng pos, String nama, String alamat) {
    final bool aktif = kantorTerpilih == nama;
    return ActionChip(
      avatar: Icon(
        Icons.place,
        size: 16,
        color: aktif ? Colors.white : Colors.teal,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: aktif ? Colors.white : Colors.teal.shade900,
        ),
      ),
      backgroundColor: aktif ? Colors.teal : Colors.white,
      elevation: 2,
      onPressed: () => _pindahKeLokasi(pos, nama, alamat),
    );
  }
}
