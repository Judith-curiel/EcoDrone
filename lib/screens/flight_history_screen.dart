import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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
  // Ciudad Vallés, Estado de México
  final LatLng _center = LatLng(19.6400, -99.1700);

  // Modelo para cada punto de botella
  late List<BottlePoint> bottlePoints;

  @override
  void initState() {
    super.initState();
    // Generar puntos dispersos alrededor de Ciudad Vallés
    bottlePoints = _generateBottlePoints();
  }

  List<BottlePoint> _generateBottlePoints() {
    return [
      BottlePoint(LatLng(19.6400, -99.1700), 'Vuelo 1'),
      BottlePoint(LatLng(19.6402, -99.1698), 'Vuelo 1'),
      BottlePoint(LatLng(19.6398, -99.1702), 'Vuelo 1'),
      BottlePoint(LatLng(19.6405, -99.1705), 'Vuelo 2'),
      BottlePoint(LatLng(19.6395, -99.1695), 'Vuelo 2'),
      BottlePoint(LatLng(19.6403, -99.1703), 'Vuelo 3'),
      BottlePoint(LatLng(19.6397, -99.1699), 'Vuelo 3'),
      BottlePoint(LatLng(19.6401, -99.1701), 'Vuelo 1'),
      BottlePoint(LatLng(19.6404, -99.1697), 'Vuelo 2'),
      BottlePoint(LatLng(19.6396, -99.1704), 'Vuelo 3'),
      BottlePoint(LatLng(19.6402, -99.1702), 'Vuelo 1'),
      BottlePoint(LatLng(19.6399, -99.1698), 'Vuelo 2'),
      BottlePoint(LatLng(19.6406, -99.1699), 'Vuelo 3'),
      BottlePoint(LatLng(19.6394, -99.1701), 'Vuelo 1'),
      BottlePoint(LatLng(19.6403, -99.1695), 'Vuelo 2'),
      BottlePoint(LatLng(19.6400, -99.1704), 'Vuelo 3'),
      BottlePoint(LatLng(19.6407, -99.1702), 'Vuelo 1'),
      BottlePoint(LatLng(19.6395, -99.1697), 'Vuelo 2'),
      BottlePoint(LatLng(19.6401, -99.1699), 'Vuelo 3'),
      BottlePoint(LatLng(19.6398, -99.1705), 'Vuelo 1'),
      BottlePoint(LatLng(19.6404, -99.1701), 'Vuelo 2'),
      BottlePoint(LatLng(19.6396, -99.1696), 'Vuelo 3'),
      BottlePoint(LatLng(19.6403, -99.1704), 'Vuelo 1'),
      BottlePoint(LatLng(19.6399, -99.1700), 'Vuelo 2'),
      BottlePoint(LatLng(19.6405, -99.1698), 'Vuelo 3'),
    ];
  }

  List<Marker> _buildMarkers() {
    return bottlePoints.map((point) {
      return Marker(
        width: 45,
        height: 45,
        point: point.location,
        child: GestureDetector(
          onTap: () => _showBottleOptions(point),
          child: Icon(
            Icons.location_on,
            color: point.isCollected ? const Color(0xFF92FA67) : Colors.red,
            size: 40,
          ),
        ),
      );
    }).toList();
  }

  void _showBottleOptions(BottlePoint point) {
    final totalPoints = bottlePoints.length;
    final collectedPoints = bottlePoints.where((p) => p.isCollected).length;
    final remainingPoints = totalPoints - collectedPoints;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Botella encontrada',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Vuelo: ${point.flight}',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.7)
                    : Colors.black.withOpacity(0.7),
              ),
            ),
            Text(
              'Estado: ${point.isCollected ? "✓ Recogida" : "Pendiente"}',
              style: TextStyle(
                color: point.isCollected ? const Color(0xFF92FA67) : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Opción de recoger manualmente si hay menos de 20
            if (remainingPoints < 20)
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    point.isCollected = true;
                  });
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.cleaning_services),
                label: const Text('Recoger'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF92FA67),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
              )
            else
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        point.isCollected = true;
                      });
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cleaning_services),
                    label: const Text('Recoger esta botella'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF92FA67),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Quedan $remainingPoints botellas',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.6)
                          : Colors.black.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 10),
            // Botón para marcar todos como limpios (solo si 20-100 puntos)
            if (remainingPoints >= 20 && remainingPoints <= 100)
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: Theme.of(
                        context,
                      ).scaffoldBackgroundColor,
                      title: const Text('¿Marcar todos como limpios?'),
                      content: Text(
                        'Esto marcará las $remainingPoints botellas restantes como recogidas.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              for (var p in bottlePoints) {
                                if (!p.isCollected) {
                                  p.isCollected = true;
                                }
                              }
                            });
                            Navigator.pop(ctx);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF92FA67),
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('Confirmar'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.check_circle),
                label: Text('Marcar todos ($remainingPoints) como limpios'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5CEEFB),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalPoints = bottlePoints.length;
    final collectedPoints = bottlePoints.where((p) => p.isCollected).length;

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
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(initialCenter: _center, initialZoom: 16.0),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.ecodrone_ai',
              ),
              MarkerLayer(markers: _buildMarkers()),
            ],
          ),
          // Estadísticas en la esquina superior
          Positioned(
            top: 15,
            right: 15,
            left: 15,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.black.withOpacity(0.7)
                    : Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF5CEEFB).withOpacity(0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 24,
                      ),
                      Text(
                        '${totalPoints - collectedPoints}',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Text('Por recoger', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                  Column(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF92FA67),
                        size: 24,
                      ),
                      Text(
                        '$collectedPoints',
                        style: const TextStyle(
                          color: Color(0xFF92FA67),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Text('Recogidas', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                  Column(
                    children: [
                      const Icon(
                        Icons.bar_chart,
                        color: Color(0xFF5CEEFB),
                        size: 24,
                      ),
                      Text(
                        '${(collectedPoints * 100 ~/ totalPoints).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Color(0xFF5CEEFB),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Text('Progreso', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Clase para representar un punto de botella
class BottlePoint {
  final LatLng location;
  final String flight;
  bool isCollected;

  BottlePoint(this.location, this.flight, {this.isCollected = false});
}
