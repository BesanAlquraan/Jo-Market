import 'package:flutter/material.dart';
import 'onboarding3_screen.dart';
class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F3EF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Column(
            children: [
              /// Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// Image Card
              Container(
                height: 360,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFAEEEDB),
                      Color(0xFFB8F3E4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.asset(
                    "assets/onboarding2.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// Title
              const Text(
                "Turn your items into\n cash in seconds",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF244B46),
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 16),

              /// Subtitle
              const Text(
                "The fastest way to sell \nanything",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),

              const Spacer(),

              /// Continue Button
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>OnboardingScreen3()),)   ;

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F5E57),
                    elevation: 6,
                    shadowColor: Colors.green.withOpacity(0.25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 26),

              /// Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  dot(false),
                  dot(true),
                  dot(false),
                ],
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget dot(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 10,
      width: active ? 30 : 10,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF2F5E57) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}