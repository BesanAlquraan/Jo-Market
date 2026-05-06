import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  bool _isPasswordHidden = true;
  bool _isConfirmHidden = true;
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
      ),
    );
  }
  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isConfirm = false,
    TextInputType type = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
        controller: controller,
        keyboardType: type,
        obscureText: isPassword
            ? (isConfirm ? _isConfirmHidden : _isPasswordHidden)
            : false,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),

          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              (isConfirm ? _isConfirmHidden : _isPasswordHidden)
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                if (isConfirm) {
                  _isConfirmHidden = !_isConfirmHidden;
                } else {
                  _isPasswordHidden = !_isPasswordHidden;
                }
              });
            },
          )
              : null,

          filled: true,
          fillColor: Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 18, horizontal: 16),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),

        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$hint is required';
          }

          if (hint == "Email") {
            final emailRegex = RegExp(
              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
            );
            if (!emailRegex.hasMatch(value)) {
              return 'Enter a valid email';
            }
          }

          if (hint == "Phone Number") {
            if (value.length < 9) {
              return 'Enter valid phone number';
            }
          }

          if (hint == "Password") {
            if (value.length < 8) {
              return 'Minimum 8 characters';
            }
          }

          if (hint == "Confirm Password") {
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
          }

          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(230, 231, 225, 1),
        body:
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),

                /// Title
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 120),

                /// Container
                Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(190, 226, 214, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(70),
                      topRight: Radius.circular(70),
                    ),
                  ),
                  child:
                  Column(
                    children: [
                      _buildField(
                        controller: _nameController,
                        hint: "Name",
                        icon: Icons.person,
                      ),

                      _buildField(
                        controller: _emailController,
                        hint: "Email",
                        icon: Icons.email_outlined,
                        type: TextInputType.emailAddress,
                      ),

                      _buildField(
                        controller: _phoneController,
                        hint: "Phone Number",
                        icon: Icons.phone,
                        type: TextInputType.phone,
                      ),

                      _buildField(
                        controller: _passwordController,
                        hint: "Password",
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),

                      _buildField(
                        controller: _confirmPasswordController,
                        hint: "Confirm Password",
                        icon: Icons.lock_outline,
                        isPassword: true,
                        isConfirm: true,
                      ),

                      const SizedBox(height: 20),

                      /// Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                            if (!_formKey.currentState!.validate()) return;

                            setState(() => _isLoading = true);

                            try {
                              final credential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );

                              final user = credential.user;

                              if (user == null) {
                                _showSnackBar("Registration failed", Colors.red);
                                return;
                              }

                              await user.sendEmailVerification();
                              await FirebaseAuth.instance.signOut();

                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: const Text("Success 🎉"),
                                  content: const Text(
                                      "Check your email to verify your account"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => LoginScreen()),
                                        );
                                      },
                                      child: const Text("OK"),
                                    )
                                  ],
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              String message = "Something went wrong";

                              if (e.code == 'weak-password') {
                                message = "Password is too weak";
                              } else if (e.code == 'email-already-in-use') {
                                message = "Email already exists";
                              } else if (e.code == 'invalid-email') {
                                message = "Invalid email";
                              }

                              _showSnackBar(message, Colors.red);
                            } catch (e) {
                              _showSnackBar("Unexpected error", Colors.red);
                            }

                            setState(() => _isLoading = false);
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(0, 150, 136, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 5,
                          ),

                          child: _isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// Login Redirect
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
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
