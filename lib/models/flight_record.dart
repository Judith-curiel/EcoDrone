import 'package:latlong2/latlong.dart';

class FlightRecord {
  final String id;
  final String title;
  final String date;
  final String duration;
  final int totalBottles;
  final LatLng center;
  final String locationLabel;
  final double latRange;
  final double lngRange;

  const FlightRecord({
    required this.id,
    required this.title,
    required this.date,
    required this.duration,
    required this.totalBottles,
    required this.center,
    required this.locationLabel,
    required this.latRange,
    required this.lngRange,
  });

  static const List<FlightRecord> all = [
    FlightRecord(
      id: 'vuelo1',
      title: 'Vuelo 1 - Fútbol Tec Valles',
      date: 'Fecha: 2023-10-01',
      duration: 'Duración: 45 min',
      totalBottles: 30,
      center: LatLng(22.0218119, -99.0385418),
      locationLabel: 'Fútbol Tec Valles',
      latRange: 0.00012,
      lngRange: 0.00012,
    ),
    FlightRecord(
      id: 'vuelo2',
      title: 'Vuelo 2 - Voleibol de Playa Tec',
      date: 'Fecha: 2023-10-02',
      duration: 'Duración: 52 min',
      totalBottles: 25,
      center: LatLng(22.0220632, -99.0377007),
      locationLabel: 'Voleibol de Playa Tec Valles',
      latRange: 0.00008,
      lngRange: 0.00008,
    ),
    FlightRecord(
      id: 'vuelo3',
      title: 'Vuelo 3 - Béisbol Tec Valles',
      date: 'Fecha: 2023-10-03',
      duration: 'Duración: 38 min',
      totalBottles: 15,
      center: LatLng(22.022019, -99.0368729),
      locationLabel: 'Béisbol Tec Valles',
      latRange: 0.00007,
      lngRange: 0.00007,
    ),
    FlightRecord(
      id: 'vuelo4',
      title: 'Vuelo 4 - Campo de Fútbol',
      date: 'Fecha: 2023-10-04',
      duration: 'Duración: 41 min',
      totalBottles: 50,
      center: LatLng(22.0212615, -99.0367921),
      locationLabel: 'Campo de Fútbol',
      latRange: 0.00014,
      lngRange: 0.00014,
    ),
    FlightRecord(
      id: 'vuelo5',
      title: 'Vuelo 5 - Centro de Cómputo / Info / D1-D2',
      date: 'Fecha: 2023-10-05',
      duration: 'Duración: 49 min',
      totalBottles: 80,
      center: LatLng(22.0224149, -99.0360122),
      locationLabel: 'Centro de Cómputo / Centro de Información / D1-D2',
      latRange: 0.00016,
      lngRange: 0.00016,
    ),
  ];
}
