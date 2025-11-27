// import 'package:flutter/material.dart';
//
// import 'first.dart';
//
// class FirstDiv extends StatelessWidget {
//   const FirstDiv ({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Modern Login UI',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       debugShowCheckedModeBanner: false,
//       home: const LoginScreen(),
//     );
//   }
// }
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//
//   bool _isPasswordVisible = false;
//   bool _isLoading = false;
//
//   void _login() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _isLoading = true);
//
//     await Future.delayed(const Duration(seconds: 2)); // Simulate loading
//
//     setState(() => _isLoading = false);
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Welcome, ${_emailController.text.trim()}!")),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background gradient
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//
//           // Login content
//           Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Card(
//                 elevation: 10,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(24.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const SizedBox(height: 10),
//                         const Icon(Icons.lock_outline,
//                             color: Colors.blue, size: 70),
//                         const SizedBox(height: 10),
//                         Text(
//                           "Welcome Back 👋",
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue.shade700,
//                           ),
//                         ),
//                         const SizedBox(height: 30),
//
//                         // Email field
//                         TextFormField(
//                           controller: _emailController,
//                           keyboardType: TextInputType.emailAddress,
//                           decoration: InputDecoration(
//                             labelText: "Email",
//                             prefixIcon: const Icon(Icons.email_outlined),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Please enter your email";
//                             } else if (!value.contains('@')) {
//                               return "Enter a valid email";
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20),
//
//                         // Password field
//                         TextFormField(
//                           controller: _passwordController,
//                           obscureText: !_isPasswordVisible,
//                           decoration: InputDecoration(
//                             labelText: "Password",
//                             prefixIcon: const Icon(Icons.lock_outline),
//                             suffixIcon: IconButton(
//                               icon: Icon(_isPasswordVisible
//                                   ? Icons.visibility
//                                   : Icons.visibility_off),
//                               onPressed: () {
//                                 setState(() {
//                                   _isPasswordVisible = !_isPasswordVisible;
//                                 });
//                               },
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Please enter your password";
//                             } else if (value.length < 6) {
//                               return "Password must be at least 6 characters";
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 30),
//
//                         // Login button
//                         SizedBox(
//                           width: double.infinity,
//                           height: 50,
//                           child: ElevatedButton(
//                             onPressed: _isLoading ? null : _login,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blue.shade700,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child: _isLoading
//                                 ? const CircularProgressIndicator(
//                               color: Colors.white,
//                             )
//                                 : const Text(
//                               "Login",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//
//                         // Sign up link
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text("Don’t have an account? "),
//                             TextButton(
//                               onPressed: () {
//                                 // Navigate to Sign Up screen
//                                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => First(),));
//                               },
//                               child: const Text(
//                                 "Sign Up",
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
