import 'package:flutter/material.dart';
import 'main_dashboard_screen.dart';
import 'recover_access_screen.dart';
import '../services/api_service.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  // 1. CONTROLADORES para capturar el texto
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  // 2. FUNCIÓN PARA ENVIAR EL JSON AL BACKEND
  void _iniciarSesion() async {
    String username = _userController.text.trim();
    String password = _passController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor rellene los campos")),
      );
      return;
    }

    try {
      // 1. Llamamos al servicio que creaste
      final resultado = await ApiService.login(username, password);

      if (resultado != null) {
        // 2. Si todo sale bien, navegamos al Dashboard
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainDashboardScreen(),
            ),
          );
        }
      }
    } catch (e) {
      // 3. Si hay un error (usuario incorrecto, servidor caído, etc.)
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final textFieldFill = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.05);
    final textFieldBorder = isDark ? Colors.white10 : Colors.black12;
    final accentColor = isDark
        ? const Color(0xFF5CEEFB)
        : const Color(0xFF00838F); // Un azul más oscuro para modo claro

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/logonom_sin_fondo.png',
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "INICIAR SESIÓN",
                style: TextStyle(
                  color: accentColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 50),
              _buildTextField(
                label: "NOMBRE DE USUARIO",
                icon: Icons.person_outline,
                controller: _userController,
                isDark: isDark,
                textColor: textColor,
                fillColor: textFieldFill,
                borderColor: textFieldBorder,
              ),
              const SizedBox(height: 25),
              _buildTextField(
                label: "CONTRASEÑA",
                icon: Icons.lock_outline,
                isPassword: true,
                controller: _passController,
                isDark: isDark,
                textColor: textColor,
                fillColor: textFieldFill,
                borderColor: textFieldBorder,
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecoverAccessScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "¿Olvidó su acceso?",
                    style: TextStyle(
                      color: isDark ? Colors.white38 : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: _iniciarSesion,
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: accentColor, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "ACCEDER AL SISTEMA",
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required bool isDark,
    required Color textColor,
    required Color fillColor,
    required Color borderColor,
    bool isPassword = false,
  }) {
    const greenAccent = Color(0xFF92FA67);
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: textColor, fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        labelText: label,
        labelStyle: TextStyle(
          color: isDark ? Colors.white38 : Colors.black54,
          fontSize: 11,
        ),
        prefixIcon: Icon(icon, color: greenAccent, size: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: greenAccent),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }
}
