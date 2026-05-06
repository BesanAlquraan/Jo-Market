import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(230, 231, 225, 1),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 250),



                /// 🔹 Main Container (SAME STYLE)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 30),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(190, 226, 214, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(70),
                      topRight: Radius.circular(70),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /// Title
                      const Center(
                        child: Text(
                          "Forget Password",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// Subtitle (small improvement)
                      const Center(
                        child: Text(
                          "Enter your email to reset your password",
                          style: TextStyle(color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 40),

                      /// 🔹 Email Field (IDENTICAL STYLE)
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode:
                          AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon:
                            const Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                            const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }

                            final emailRegex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            );

                            if (!emailRegex.hasMatch(value)) {
                              return 'Enter a valid email';
                            }

                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// 🔹 Send Button (SAME STYLE)
                      SizedBox(
                        height: 55,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;

                              try {
                                await FirebaseAuth.instance.sendPasswordResetEmail(
                                  email: _emailController.text.trim(),
                                );

                                _emailController.clear();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      "📩 Password reset link sent! Check your email",
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );

                              } on FirebaseAuthException catch (e) {
                                String message = "Something went wrong";

                                if (e.code == 'user-not-found') {
                                  message = "🚫 No account found with this email";
                                } else if (e.code == 'invalid-email') {
                                  message = "⚠️ Invalid email format";
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(message),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text("❌ Unexpected error, try again"),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color.fromRGBO(0, 150, 136, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(14),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            "Send",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// 🔹 Back to Login
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Back to Login",
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}