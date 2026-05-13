import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'login_form_screen.dart';
import 'register_form_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/bg_drone.mp4')
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.setVolume(0);
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // LoginScreen SIEMPRE usa tema oscuro, ignora la configuración global
    const backgroundColor = Color(0xFF0C0E11);
    const gradientColor = Color.fromRGBO(12, 14, 17, 0.4);
    const gradientEndColor = Color.fromRGBO(12, 14, 17, 0.8);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // 1. FONDO: VIDEO
          Positioned.fill(
            child: _controller.value.isInitialized
                ? Transform.scale(
                    scale: 1.0,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  )
                : Container(color: Colors.black),
          ),

          // 2. Capa de Gradiente
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [gradientColor, Colors.transparent, gradientEndColor],
              ),
            ),
          ),

          // 4. INTERFAZ
          SafeArea(
            child: Column(
              children: [
                // --- HEADER CON LOGO Y NOMBRE EN BLANCO ---
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          'assets/logo_sin_fondo.png',
                          height: 45,
                          width: 45,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Text(
                        "ECODRONE AI",
                        style: TextStyle(
                          color: Colors.white, // <--- Cambiado a Blanco
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Botones de Acción
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 50,
                  ),
                  child: Column(
                    children: [
                      _buildLoginButton(context),
                      const SizedBox(height: 20),
                      _buildRegisterText(context), // <--- Pasamos context aquí
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- BOTÓN DE LOGIN EN COLOR AZUL CIAN ---
  Widget _buildLoginButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: const Color(0xFF5CEEFB),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5CEEFB).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginFormScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          "INICIAR SESIÓN",
          style: TextStyle(
            color: Color(0xFF0C0E11),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  // --- TEXTO DE REGISTRO CON NAVEGACIÓN ---
  Widget _buildRegisterText(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterFormScreen()),
        );
      },
      child: const Text.rich(
        TextSpan(
          text: "¿No tienes cuenta? ",
          style: TextStyle(color: Colors.white70, fontSize: 13),
          children: [
            TextSpan(
              text: "REGÍSTRATE",
              style: TextStyle(
                color: Color(0xFF5CEEFB),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xFF5CEEFB).withOpacity(0.05)
      ..strokeWidth = 1.0;
    for (double i = 0; i < size.height; i += 4) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
