
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:languageapp/feature/student/presentation/screens/student/home_screen.dart';
import 'package:languageapp/feature/teacher/presentation/screens/dashboard_screen.dart';

import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  static const String name = '/signup';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Extra teacher field
  final TextEditingController _subjectController = TextEditingController();

  final String role = Get.arguments?["role"] ?? "Student";

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 200),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(_nameController, 'Full Name', Icons.person),
                    const SizedBox(height: 15),
                    _buildTextField(
                      _emailController,
                      'Email',
                      Icons.email,
                      TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),

                    // Extra field for teachers
                    if (role == "Teacher") ...[
                      _buildTextField(
                        _subjectController,
                        'Subject',
                        Icons.book,
                      ),
                      const SizedBox(height: 15),
                    ],

                    _buildPasswordField(
                      _passwordController,
                      'Password',
                      _obscurePassword,
                      () => setState(() =>
                          _obscurePassword = !_obscurePassword),
                    ),
                    const SizedBox(height: 15),
                    _buildPasswordField(
                      _confirmPasswordController,
                      'Confirm Password',
                      _obscureConfirmPassword,
                      () => setState(() =>
                          _obscureConfirmPassword = !_obscureConfirmPassword),
                      confirmPasswordCheck: true,
                    ),
                    const SizedBox(height: 30),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(220, 50),
                        backgroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final name = _nameController.text.trim();
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          try {
                            UserCredential userCredential =
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: email, password: password);

                            final collection =
                                role == "Teacher" ? "teachers" : "students";

                            Map<String, dynamic> userData = {
                              "name": name,
                              "email": email,
                              "role": role,
                              "createdAt": Timestamp.now(),
                            };

                            if (role == "Teacher") {
                              userData["subject"] =
                                  _subjectController.text.trim();
                            }

                            await FirebaseFirestore.instance
                                .collection(collection)
                                .doc(userCredential.user!.uid)
                                .set(userData);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Signup successful")),
                            );
      // Navigate based on role
      if (role == "Teacher") {
  Navigator.push(context, MaterialPageRoute(builder: (context)=>TeacherDashboardScreen())); // Replace with your teacher route
      } else {
  Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentHomeScreen()));// Replace with your student route
      }

                          } on FirebaseAuthException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(e.message ?? "Signup failed")),
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    Get.to(() => LoginScreens());
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Text Field
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, [
    TextInputType type = TextInputType.text,
  ]) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.indigo, width: 2),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Enter $label' : null,
    );
  }

  // Password Field with toggle
  Widget _buildPasswordField(
    TextEditingController controller,
    String label,
    bool obscureText,
    VoidCallback toggleVisibility, {
    bool confirmPasswordCheck = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon:
              Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.indigo, width: 2),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'Enter $label';
        if (confirmPasswordCheck && value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}
