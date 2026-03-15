// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:jolu_trip/services/auth_service.dart';
// import 'package:jolu_trip/constants/app_colors.dart';

// class PhoneAuthScreen extends StatefulWidget {
//   const PhoneAuthScreen({super.key});

//   @override
//   State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
// }

// class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _codeController = TextEditingController();
//   String _verificationId = '';
//   bool _isCodeSent = false;

//   @override
//   Widget build(BuildContext context) {
//     final authService = Provider.of<AuthService>(context);

//     return Scaffold(
//       backgroundColor: AppColors.darkTheme.scaffoldBackgroundColor,
//       appBar: AppBar(
//         title: const Text('Вход по телефону'),
//         backgroundColor: Colors.transparent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           children: [
//             if (!_isCodeSent) ...[
//               TextField(
//                 controller: _phoneController,
//                 style: const TextStyle(color: Colors.white),
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   hintText: '+996 XXX XXX XXX',
//                   hintStyle: TextStyle(color: Colors.grey[400]),
//                   prefixIcon: const Icon(Icons.phone, color: Colors.grey),
//                   filled: true,
//                   fillColor: Colors.white.withOpacity(0.1),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: authService.isLoading
//                       ? null
//                       : () {
//                           authService.signInWithPhone(
//                             phoneNumber: _phoneController.text,
//                             onCodeSent: (verificationId) {
//                               setState(() {
//                                 _verificationId = verificationId;
//                                 _isCodeSent = true;
//                               });
//                             },
//                             onError: (error) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(error),
//                                   backgroundColor: Colors.red,
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                   ),
//                   child: authService.isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text('Отправить код'),
//                 ),
//               ),
//             ] else ...[
//               TextField(
//                 controller: _codeController,
//                 style: const TextStyle(color: Colors.white),
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   hintText: 'XXXXXX',
//                   hintStyle: TextStyle(color: Colors.grey[400]),
//                   prefixIcon: const Icon(Icons.message, color: Colors.grey),
//                   filled: true,
//                   fillColor: Colors.white.withOpacity(0.1),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: authService.isLoading
//                       ? null
//                       : () {
//                           authService.verifyPhoneCode(
//                             verificationId: _verificationId,
//                             smsCode: _codeController.text,
//                             onSuccess: () {
//                               Navigator.pop(context);
//                             },
//                             onError: (error) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(error),
//                                   backgroundColor: Colors.red,
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                   ),
//                   child: authService.isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text('Подтвердить'),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
