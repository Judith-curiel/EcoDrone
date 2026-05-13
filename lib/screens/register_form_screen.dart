import 'package:flutter/material.dart';

class RegisterFormScreen extends StatelessWidget {
  const RegisterFormScreen({super.key});

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
        : const Color(0xFF00838F); // Azul oscuro para legibilidad en modo claro

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
              const SizedBox(height: 10),
              Center(
                child: Image.asset(
                  'assets/logonom_sin_fondo.png',
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "CREAR CUENTA",
                style: TextStyle(
                  color: accentColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 40),
              _buildTextField(
                label: "NOMBRE COMPLETO",
                icon: Icons.badge_outlined,
                isDark: isDark,
                textColor: textColor,
                fillColor: textFieldFill,
                borderColor: textFieldBorder,
              ),
              const SizedBox(height: 25),
              _buildTextField(
                label: "CORREO ELECTRÓNICO",
                icon: Icons.email_outlined,
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
                isDark: isDark,
                textColor: textColor,
                fillColor: textFieldFill,
                borderColor: textFieldBorder,
              ),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  // Acción de registro
                },
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
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "FINALIZAR REGISTRO",
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required bool isDark,
    required Color textColor,
    required Color fillColor,
    required Color borderColor,
    bool isPassword = false,
  }) {
    const greenAccent = Color(0xFF92FA67);
    return TextField(
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
