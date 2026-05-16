import 'package:flutter/material.dart';
import '../models/flight_record.dart';
import '../widgets/statistics_panel.dart';

class StatisticsScreen extends StatelessWidget {
  final FlightRecord flight;
  final int collected;
  final int total;

  const StatisticsScreen({
    super.key,
    required this.flight,
    required this.collected,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? const Color(0xFF5CEEFB) : Colors.black87,
        ),
        title: Text(
          'Panel de Estadísticas',
          style: TextStyle(
            color: isDark ? const Color(0xFF5CEEFB) : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: StatisticsPanel(flight: flight, collected: collected, total: total),
    );
  }
}
