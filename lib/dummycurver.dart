// import 'package:flutter/material.dart';
//
// class HkCustomCurvedEdges extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     path.lineTo(0, size.height - 40);
//
//     final firstControlPoint = Offset(0, size.height);
//     final firstEndPoint = Offset(40, size.height);
//     path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
//
//     path.lineTo(size.width - 40, size.height);
//     final secondControlPoint = Offset(size.width, size.height);
//     final secondEndPoint = Offset(size.width, size.height - 40);
//     path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
//
//     path.lineTo(size.width, 0);
//     path.close();
//
//     return path;
//   }
//
//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }
//
//
// class HkCurvedContainer extends StatelessWidget {
//   final Widget? child;
//
//   const HkCurvedContainer({super.key, this.child});
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipPath(
//       clipper: HkCustomCurvedEdges(),
//       child: Container(
//         color: const Color(0xFF0F52BA),
//         padding: const EdgeInsets.only(bottom: 40),
//         child: child,
//       ),
//     );
//   }
// }
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             HkCurvedContainer(
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
//                 child: const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Good Morning",
//                       style: TextStyle(color: Colors.white70, fontSize: 16),
//                     ),
//                     Text(
//                       "Unknown Pro",
//                       style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 20),
//                     // यहाँ आपके Popular Categories वाले आइकॉन्स आ जायेंगे...
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
