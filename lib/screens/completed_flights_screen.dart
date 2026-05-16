import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/flight_record.dart';
import '../screens/statistics_screen.dart';
import '../services/flight_storage.dart';

class CompletedFlightsScreen extends StatefulWidget {
  const CompletedFlightsScreen({super.key});

  @override
  State<CompletedFlightsScreen> createState() => _CompletedFlightsScreenState();
}

class _CompletedFlightsScreenState extends State<CompletedFlightsScreen> {
  Map<String, int> _flightProgress = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final progress = await FlightStorage.loadAllCollectedCounts(
      FlightRecord.all.map((flight) => flight.id).toList(),
    );

    if (!mounted) return;
    setState(() {
      _flightProgress = progress;
      _isLoading = false;
    });
  }

  List<FlightRecord> get _completedFlights {
    return FlightRecord.all.where((flight) {
      final collected = _flightProgress[flight.id] ?? 0;
      return collected >= flight.totalBottles;
    }).toList();
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
          'Vuelos Completados',
          style: TextStyle(
            color: isDark ? const Color(0xFF5CEEFB) : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _completedFlights.isEmpty
            ? _buildEmptyMessage(
                'No hay vuelos completados aún. Completa vuelos para verlos aquí.',
              )
            : ListView(
                padding: const EdgeInsets.all(20),
                children: _completedFlights.map(_buildFlightCard).toList(),
              ),
      ),
    );
  }

  Widget _buildEmptyMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.7)
                : Colors.black.withOpacity(0.7),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildFlightCard(FlightRecord flight) {
    final collected = _flightProgress[flight.id] ?? 0;
    final progressPercent = '100%';

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlightMapScreen(flight: flight),
          ),
        );
        _loadProgress();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF92FA67).withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              flight.title,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${flight.date} · ${flight.duration}',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.7)
                    : Colors.black.withOpacity(0.7),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$collected de ${flight.totalBottles} botellas',
                  style: const TextStyle(
                    color: Color(0xFF92FA67),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$progressPercent completado',
                  style: const TextStyle(
                    color: Color(0xFF92FA67),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FlightMapScreen extends StatefulWidget {
  final FlightRecord flight;

  const FlightMapScreen({super.key, required this.flight});

  @override
  State<FlightMapScreen> createState() => _FlightMapScreenState();
}

class _FlightMapScreenState extends State<FlightMapScreen> {
  late LatLng _center;
  late String _locationLabel;
  late List<BottlePoint> bottlePoints;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _center = widget.flight.center;
    _locationLabel = widget.flight.locationLabel;
    bottlePoints = _generateBottlePoints(widget.flight);
    _loadSavedProgress();
  }

  Future<void> _loadSavedProgress() async {
    final savedCount = await FlightStorage.loadCollectedCount(widget.flight.id);
    if (!mounted) return;
    setState(() {
      for (var i = 0; i < savedCount && i < bottlePoints.length; i++) {
        bottlePoints[i].isCollected = true;
      }
      _isLoading = false;
    });
  }

  List<BottlePoint> _generateBottlePoints(FlightRecord flight) {
    final random = Random(1234 + flight.totalBottles);

    return List.generate(flight.totalBottles, (index) {
      final angle = random.nextDouble() * 2 * pi;
      final radius = sqrt(random.nextDouble());
      final latOffset = cos(angle) * radius * flight.latRange * 0.75;
      final lngOffset = sin(angle) * radius * flight.lngRange * 0.75;

      return BottlePoint(
        LatLng(
          flight.center.latitude + latOffset,
          flight.center.longitude + lngOffset,
        ),
        widget.flight.title,
      );
    });
  }

  Future<void> _saveProgress() async {
    final collectedPoints = bottlePoints.where((p) => p.isCollected).length;
    await FlightStorage.saveCollectedCount(widget.flight.id, collectedPoints);
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
            if (!point.isCollected)
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    point.isCollected = true;
                  });
                  _saveProgress();
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
              Text(
                'Esta botella ya está recogida.',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.7)
                      : Colors.black.withOpacity(0.7),
                ),
              ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: remainingPoints > 0
                  ? () {
                      setState(() {
                        for (var p in bottlePoints) {
                          p.isCollected = true;
                        }
                      });
                      _saveProgress();
                      Navigator.pop(context);
                    }
                  : null,
              icon: const Icon(Icons.check_circle),
              label: Text(
                remainingPoints > 0
                    ? 'Marcar todos como recogidos'
                    : 'Todas recogidas',
              ),
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
          widget.flight.title,
          style: TextStyle(
            color: isDark ? const Color(0xFF5CEEFB) : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: _center,
                    initialZoom: 17.0,
                  ),
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
                            const Text(
                              'Por recoger',
                              style: TextStyle(fontSize: 10),
                            ),
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
                            const Text(
                              'Recogidas',
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white10 : Colors.black12,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => StatisticsScreen(
                                      flight: widget.flight,
                                      collected: collectedPoints,
                                      total: totalPoints,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 12,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.bar_chart,
                                      color: Color(0xFF5CEEFB),
                                      size: 24,
                                    ),
                                    Text(
                                      '${(collectedPoints * 100 / totalPoints).toStringAsFixed(0)}%',
                                      style: const TextStyle(
                                        color: Color(0xFF5CEEFB),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Text(
                                      'Progreso',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  left: 15,
                  right: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.black.withOpacity(0.7)
                          : Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF5CEEFB).withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      'Ubicación: $_locationLabel',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class BottlePoint {
  final LatLng location;
  final String flight;
  bool isCollected;

  BottlePoint(this.location, this.flight, {this.isCollected = false});
}
