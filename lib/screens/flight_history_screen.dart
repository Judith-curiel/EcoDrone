import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FlightHistoryScreen extends StatelessWidget {
  const FlightHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? const Color(0xFF5CEEFB) : Colors.black87,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Historia de Vuelo',
          style: TextStyle(
            color: isDark ? const Color(0xFF5CEEFB) : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildFlightItem(
              context,
              'Vuelo 1 - Zona A',
              'Fecha: 2023-10-01',
              'Duración: 45 min',
              'Botellas recolectadas: 12',
              isDark,
            ),
            const SizedBox(height: 20),
            _buildFlightItem(
              context,
              'Vuelo 2 - Zona B',
              'Fecha: 2023-10-02',
              'Duración: 52 min',
              'Botellas recolectadas: 18',
              isDark,
            ),
            const SizedBox(height: 20),
            _buildFlightItem(
              context,
              'Vuelo 3 - Zona C',
              'Fecha: 2023-10-03',
              'Duración: 38 min',
              'Botellas recolectadas: 9',
              isDark,
            ),
            const SizedBox(height: 20),
            _buildFlightItem(
              context,
              'Vuelo 4 - Zona A',
              'Fecha: 2023-10-04',
              'Duración: 41 min',
              'Botellas recolectadas: 15',
              isDark,
            ),
            const SizedBox(height: 20),
            _buildFlightItem(
              context,
              'Vuelo 5 - Zona D',
              'Fecha: 2023-10-05',
              'Duración: 49 min',
              'Botellas recolectadas: 22',
              isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightItem(
    BuildContext context,
    String title,
    String date,
    String duration,
    String bottles,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () {
        // Navegar a la pantalla de mapa
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlightMapScreen(flightTitle: title),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF5CEEFB).withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flight, color: const Color(0xFF92FA67), size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              date,
              style: TextStyle(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.7)
                    : Colors.black.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              duration,
              style: TextStyle(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.7)
                    : Colors.black.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              bottles,
              style: TextStyle(
                color: const Color(0xFF92FA67),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlightMapScreen extends StatefulWidget {
  final String flightTitle;

  const FlightMapScreen({super.key, required this.flightTitle});

  @override
  State<FlightMapScreen> createState() => _FlightMapScreenState();
}

class _FlightMapScreenState extends State<FlightMapScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(
    19.4326,
    -99.1332,
  ); // Ejemplo: Ciudad de México

  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('bottle1'),
      position: LatLng(19.4326, -99.1332),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ),
    Marker(
      markerId: MarkerId('bottle2'),
      position: LatLng(19.4330, -99.1340),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ),
    Marker(
      markerId: MarkerId('bottle3'),
      position: LatLng(19.4315, -99.1325),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ),
    // Agregar más marcadores según sea necesario
  };

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? const Color(0xFF5CEEFB) : Colors.black87,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.flightTitle,
          style: TextStyle(
            color: isDark ? const Color(0xFF5CEEFB) : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: _center, zoom: 15.0),
          markers: _markers,
        ),
      ),
    );
  }
}
