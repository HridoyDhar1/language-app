import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:languageapp/blocs/auth/auth_bloc.dart';
import 'package:languageapp/blocs/auth/auth_event.dart';
import 'package:languageapp/blocs/auth/auth_state.dart';
import 'package:languageapp/feature/auth/presentation/screens/singup_screen.dart';

import 'package:languageapp/feature/student/presentation/screens/student/home_screen.dart';
import 'package:languageapp/feature/teacher/presentation/screens/dashboard_screen.dart';


class LoginScreens extends StatefulWidget {
  const LoginScreens({super.key});

  static const String name = '/login';

  @override
  State<LoginScreens> createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreens>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String selectedRole = "Student";

  late AnimationController _containerController;
  late Animation<Offset> _containerSlide;
  late Animation<double> _containerFade;
  late AnimationController _staggerController;
  late Animation<double> _roleFade, _emailFade, _passwordFade, _buttonFade, _signupFade;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _containerController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _containerSlide = Tween<Offset>(begin: const Offset(0, 1.5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _containerController, curve: Curves.elasticOut));
    _containerFade = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _containerController, curve: Curves.easeIn));
    _containerController.forward();

    _staggerController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));

    _roleFade = _createFadeTween(0.0, 0.2);
    _emailFade = _createFadeTween(0.2, 0.4);
    _passwordFade = _createFadeTween(0.4, 0.6);
    _buttonFade = _createFadeTween(0.6, 0.8);
    _signupFade = _createFadeTween(0.8, 1.0);

    _staggerController.forward();
  }

  Animation<double> _createFadeTween(double start, double end) =>
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _staggerController, curve: Interval(start, end, curve: Curves.easeIn)),
      );

  @override
  void dispose() {
    _containerController.dispose();
    _staggerController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              if (state.role == "Teacher") {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => TeacherDashboardScreen()));
              } else {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => StudentHomeScreen()));
              }
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 100),
                const Text("Language App", style: TextStyle(fontSize: 50)),
                const SizedBox(height: 50),
                SlideTransition(
                  position: _containerSlide,
                  child: FadeTransition(
                    opacity: _containerFade,
                    child: _buildForm(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Container(
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
            FadeTransition(
              opacity: _roleFade,
              child: ToggleButtons(
                borderRadius: BorderRadius.circular(15),
                fillColor: Colors.indigo.shade100,
                selectedColor: Colors.indigo,
                isSelected: [selectedRole == "Student", selectedRole == "Teacher"],
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
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _emailFade,
              child: _buildTextField(
                  _emailController,
                  selectedRole == "Teacher" ? 'Teacher Email' : 'Student Email',
                  TextInputType.emailAddress,
                  icon: selectedRole == "Teacher" ? Icons.school : Icons.person),
            ),
            const SizedBox(height: 15),
            FadeTransition(opacity: _passwordFade, child: _buildPasswordField()),
            const SizedBox(height: 30),
            FadeTransition(
              opacity: _buttonFade,
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(220, 50),
                      backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(LoginUser(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                  role: selectedRole));
                            }
                          },
                    child: state is AuthLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _signupFade,
              child: Row(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, TextInputType type,
      {IconData? icon}) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.grey)),
        focusedBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.indigo, width: 2)),
      ),
      validator: (value) => value!.isEmpty ? 'Enter $label' : null,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.grey)),
        focusedBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.indigo, width: 2)),
      ),
      validator: (value) => value!.isEmpty ? 'Enter Password' : null,
    );
  }
}
