import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'flight_history_screen.dart';
import 'pending_flights_screen.dart';
import 'completed_flights_screen.dart';
import '../models/flight_record.dart';
import '../services/flight_storage.dart';
import '../theme_manager.dart';

class MainDashboardScreen extends StatelessWidget {
  const MainDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          children: [
            const SizedBox(height: 100),
            _buildDrawerItem(Icons.settings, "CONFIGURACIÓN", () {}, isDark),
            _buildDrawerItem(Icons.history, "HISTORIAL", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FlightHistoryScreen(),
                ),
              );
            }, isDark),
            _buildDrawerItem(Icons.pending_actions, "VUELOS PENDIENTES", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PendingFlightsScreen(),
                ),
              );
            }, isDark),
            _buildDrawerItem(Icons.check_circle, "VUELOS COMPLETADOS", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CompletedFlightsScreen(),
                ),
              );
            }, isDark),
            _buildDrawerItem(
              isDark
                  ? Icons.wb_sunny_outlined
                  : Icons.nightlight_round_outlined,
              isDark ? "MODO CLARO" : "MODO OSCURO",
              () {
                themeModeNotifier.value = isDark
                    ? ThemeMode.light
                    : ThemeMode.dark;
              },
              isDark,
            ),
            _buildDrawerItem(Icons.logout, "CERRAR SESIÓN", () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            }, isDark),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: isDark
                            ? const Color(0xFF5CEEFB)
                            : Colors.black87,
                      ),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  Image.asset(
                    'assets/logonom_sin_fondo.png',
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF92FA67),
                    radius: 18,
                    child: Icon(
                      Icons.person,
                      color: isDark ? Colors.black : Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF5CEEFB).withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "SISTEMA ACTIVO",
                      style: TextStyle(
                        color: Color(0xFF92FA67),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Bienvenido al panel de vuelos",
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    FutureBuilder<Map<String, int>>(
                      future: FlightStorage.loadAllCollectedCounts(
                        FlightRecord.all.map((flight) => flight.id).toList(),
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text(
                            'Cargando estado de vuelos...',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.black.withOpacity(0.5),
                              fontSize: 13,
                            ),
                          );
                        }

                        final progress = snapshot.data!;
                        final pending = FlightRecord.all
                            .where(
                              (flight) =>
                                  (progress[flight.id] ?? 0) <
                                  flight.totalBottles,
                            )
                            .length;
                        final completed = FlightRecord.all
                            .where(
                              (flight) =>
                                  (progress[flight.id] ?? 0) >=
                                  flight.totalBottles,
                            )
                            .length;

                        return Text(
                          'Vuelos pendientes: $pending · Vuelos terminados: $completed',
                          style: TextStyle(
                            color: isDark
                                ? Colors.white.withOpacity(0.5)
                                : Colors.black.withOpacity(0.5),
                            fontSize: 13,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    VoidCallback onTap,
    bool isDark,
  ) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF92FA67)),
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? const Color(0xFF5CEEFB) : Colors.black87,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }
}
