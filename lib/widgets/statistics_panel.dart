import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/flight_record.dart';
import '../services/flight_storage.dart';

class StatisticsPanel extends StatefulWidget {
  final FlightRecord flight;
  final int collected;
  final int total;

  const StatisticsPanel({
    super.key,
    required this.flight,
    required this.collected,
    required this.total,
  });

  @override
  State<StatisticsPanel> createState() => _StatisticsPanelState();
}

class _StatisticsPanelState extends State<StatisticsPanel> {
  Map<String, int> _allCounts = {};

  @override
  void initState() {
    super.initState();
    _loadAllCounts();
  }

  Future<void> _loadAllCounts() async {
    final ids = FlightRecord.all.map((f) => f.id).toList();
    final counts = await FlightStorage.loadAllCollectedCounts(ids);
    if (!mounted) return;
    setState(() => _allCounts = counts);
  }

  List<PieChartSectionData> _buildPieSections() {
    final detected = widget.collected; // here treated as detected
    final remaining = (widget.total - widget.collected).clamp(0, widget.total);

    return [
      PieChartSectionData(
        value: detected.toDouble(),
        color: const Color(0xFF92FA67),
        radius: 40,
        title: '',
      ),
      PieChartSectionData(
        value: remaining.toDouble(),
        color: Colors.grey.shade300,
        radius: 40,
        title: '',
      ),
    ];
  }

  List<BarChartGroupData> _buildBarGroups() {
    final groups = <BarChartGroupData>[];
    for (var i = 0; i < FlightRecord.all.length; i++) {
      final f = FlightRecord.all[i];
      final value = (_allCounts[f.id] ?? 0).toDouble();
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(toY: value, color: const Color(0xFF5CEEFB)),
          ],
        ),
      );
    }
    return groups;
  }

  Map<String, double> _mockSizeDistribution() {
    return {
      'Chicas (≤ 600 ml)': 28.0,
      'Medianas (1 - 1.5 L)': 52.0,
      'Grandes / Retornables (2 - 3 L)': 20.0,
    };
  }

  Map<String, double> _mockConditionDistribution() {
    return {
      'Aplastada / Compacta': 45.0,
      'Entera / Con líquido': 30.0,
      'Degradada / Semienterrada': 25.0,
    };
  }

  List<PieChartSectionData> _buildPieSectionsFromMap(
    Map<String, double> data,
    List<Color> colors,
  ) {
    final entries = data.entries.toList();
    return List.generate(
      entries.length,
      (index) => PieChartSectionData(
        value: entries[index].value,
        color: colors[index % colors.length],
        radius: 40,
        title: '',
      ),
    );
  }

  Widget _buildHorizontalDistribution(Map<String, double> data, bool isDark) {
    final colors = [
      const Color(0xFF5CEEFB),
      const Color(0xFF92FA67),
      const Color(0xFFF9A825),
      const Color(0xFFEF5350),
    ];

    final entries = data.entries.toList();
    return Column(
      children: entries.asMap().entries.map((entry) {
        final index = entry.key;
        final label = entry.value.key;
        final value = entry.value.value;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  label,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    Container(
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: (value.clamp(0, 100) / 100),
                      child: Container(
                        height: 18,
                        decoration: BoxDecoration(
                          color: colors[index % colors.length],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 40,
                child: Text(
                  '${value.toStringAsFixed(0)}%',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sizeDist = _mockSizeDistribution();
    final conditionDist = _mockConditionDistribution();

    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Eficiencia de Recolección',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: SizedBox(
                height: 160,
                child: PieChart(
                  PieChartData(
                    sections: _buildPieSections(),
                    centerSpaceRadius: 48,
                    sectionsSpace: 2,
                    startDegreeOffset: -90,
                    borderData: FlBorderData(show: false),
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 600),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '${widget.collected} detectadas · ${widget.total} totales',
                style: TextStyle(
                  color: isDark ? Colors.white.withAlpha(204) : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Densidad por vuelo (histórico)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  barGroups: _buildBarGroups(),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(show: false),
                  gridData: FlGridData(show: false),
                  barTouchData: BarTouchData(enabled: false),
                ),
                swapAnimationDuration: const Duration(milliseconds: 600),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Distribución por tamaño / capacidad de la botella',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildHorizontalDistribution(sizeDist, isDark),
            const SizedBox(height: 20),
            Text(
              'Distribución por estado de la botella',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: SizedBox(
                height: 180,
                child: PieChart(
                  PieChartData(
                    sections: _buildPieSectionsFromMap(conditionDist, const [
                      Color(0xFF5CEEFB),
                      Color(0xFF92FA67),
                      Color(0xFFF9A825),
                    ]),
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                    startDegreeOffset: -90,
                    borderData: FlBorderData(show: false),
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 600),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: conditionDist.entries
                  .map(
                    (e) => Chip(
                      label: Text('${e.key}: ${e.value.toStringAsFixed(0)}%'),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
