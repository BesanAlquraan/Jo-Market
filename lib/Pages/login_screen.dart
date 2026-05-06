import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'forget_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordHidden = true;
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
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
                const SizedBox(height: 80),

                /// Logo
                Image.asset(
                  "assets/loginlogo.png",
                  height: 200,
                  width: 200,
                ),

                const SizedBox(height: 40),

                /// Main Container
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
                          "Login",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      /// Email Field
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

                      const SizedBox(height: 25),

                      /// Password Field
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
                          controller: _passwordController,
                          obscureText: _isPasswordHidden,

                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon:
                            const Icon(Icons.lock_outline),

                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordHidden =
                                  !_isPasswordHidden;
                                });
                              },
                            ),

                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                            const EdgeInsets.symmetric(
                                vertical: 18),
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }

                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }

                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ForgetScreen()),
                            );
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// Login Button
                      SizedBox(
                        height: 55,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;

                              try {
                                final credential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );

                                final user = credential.user;

                                if (user == null) {
                                  _showSnackBar("Login failed", Colors.red);
                                  return;
                                }

                                if (!user.emailVerified) {
                                  await FirebaseAuth.instance.signOut();

                                  _showSnackBar("Please verify your email first", Colors.orange);
                                  return;
                                }

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(), // ✅ هنا التعديل
                                  ),
                                );

                              } on FirebaseAuthException catch (e) {
                                String message = "Something went wrong";

                                if (e.code == 'user-not-found') {
                                  message = "No user found for that email";
                                } else if (e.code == 'wrong-password') {
                                  message = "Wrong password";
                                } else if (e.code == 'invalid-email') {
                                  message = "Invalid email format";
                                }

                                _showSnackBar(message, Colors.red);

                              } catch (e) {
                                _showSnackBar("Unexpected error", Colors.red);
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
                            "Login",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      /// Register
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style:
                            TextStyle(color: Colors.black54),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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