
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:languageapp/feature/auth/singup_screen.dart';
import 'package:languageapp/screens/student/home_screen.dart';
import 'package:languageapp/screens/teacher/dashboard_screen.dart';


class LoginScreens extends StatefulWidget {
  const LoginScreens({super.key});

  static const String name = '/login';

  @override
  State<LoginScreens> createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreens> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  String selectedRole = "Student"; // Default role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 250),
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
                    const SizedBox(height: 10),

                    // Role Selection Toggle
                    ToggleButtons(
                      borderRadius: BorderRadius.circular(15),
                      fillColor: Colors.indigo.shade100,
                      selectedColor: Colors.indigo,
                      isSelected: [
                        selectedRole == "Student",
                        selectedRole == "Teacher"
                      ],
                      onPressed: (index) {
                        setState(() {
                          selectedRole = index == 0 ? "Student" : "Teacher";
                        });
                      },
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Student"),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Teacher"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Email Field
                    _buildTextField(
                      _emailController,
                      selectedRole == "Teacher"
                          ? 'Teacher Email'
                          : 'Student Email',
                      TextInputType.emailAddress,
                      icon: selectedRole == "Teacher"
                          ? Icons.school
                          : Icons.person,
                    ),
                    const SizedBox(height: 15),

                    // Password Field
                    _buildPasswordField(),
                    const SizedBox(height: 30),

                    // Login Button
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
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          try {
                            // Firebase Authentication
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .signInWithEmailAndPassword(
                                    email: email, password: password);

                            // Check role in Firestore
                            final roleCollection = selectedRole == "Teacher"
                                ? "teachers"
                                : "students";

                            DocumentSnapshot doc = await FirebaseFirestore
                                .instance
                                .collection(roleCollection)
                                .doc(userCredential.user!.uid)
                                .get();

                            if (doc.exists) {
                              if (selectedRole == "Teacher") {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>TeacherDashboardScreen()));
                              } else {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentHomeScreen()));
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Role mismatch or user not found")),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(e.message ?? "Login failed")),
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Signup Redirect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Get.to(() => SignupScreen(),
                                arguments: {"role": selectedRole});
                          },
                          child: const Text("Sign Up"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Text Field Widget
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    TextInputType type, {
    IconData? icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
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

  // Password Field Widget
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.indigo, width: 2),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Enter Password' : null,
    );
  }
}
