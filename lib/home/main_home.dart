// import 'package:apk_poli/home/histori_page.dart';
// import 'package:apk_poli/home/home_page.dart';
// import 'package:apk_poli/home/layanan_page.dart';
// import 'package:apk_poli/home/profil_page.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';

// class Base extends StatefulWidget {
//   final dynamic dataPasien; // Bisa diganti sesuai tipe DataPasien
//    final String token;
//   const Base({super.key, this.dataPasien, required this.token});

//   @override
//   State<Base> createState() => _BaseState();
// }

// class _BaseState extends State<Base> with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   int currentIndex = 0;
//   int cartCount = 2;
//   int wishlistCount = 3;
 
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//    List<Widget> _buildScreens() {
//     return [
//       HomePage(dataPasien: widget.dataPasien),
//       LayananPage(),
//       const Center(child: Text("Cart Page")),
//       HistoryPage(token: widget.token),
//       ProfilePage(pasien: widget.dataPasien,)
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     // const alertColor = Colors.red;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: IndexedStack(
//         index: currentIndex,
//         children: _buildScreens(),
//       ),
//       bottomNavigationBar: Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           border: Border(
//             top: BorderSide(color: Colors.black26, width: 0.5),
//           ),
//         ),
//         child: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           selectedItemColor: Colors.blue, // ganti sesuai tema
//           unselectedItemColor: Colors.grey,
//           backgroundColor: Colors.white,
//           elevation: 0,
//           currentIndex: currentIndex,
//           onTap: (int tab) {
//             setState(() {
//               currentIndex = tab;
//             });
//           },
//           items: [
//             const BottomNavigationBarItem(
//               icon: Icon(Iconsax.home_14, size: 28),
//               label: 'Home',
//             ),
//             const BottomNavigationBarItem(
//               icon: Icon(Iconsax.shop, size: 28),
//               label: 'Layanan',
//             ),
//             BottomNavigationBarItem(
//               icon: Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   const Icon(Iconsax.bag_2, size: 28),
//                   // if (cartCount > 0)
//                   //   Positioned(
//                   //     top: -5,
//                   //     right: -5,
//                   //     child: ScaleTransition(
//                   //       scale: Tween<double>(begin: 0.7, end: 1.0).animate(
//                   //         CurvedAnimation(
//                   //           parent: _animationController,
//                   //           curve: Curves.easeInOut,
//                   //         ),
//                   //       ),
//                   //       child: CircleAvatar(
//                   //         backgroundColor: alertColor,
//                   //         radius: 11,
//                   //         child: Text(
//                   //           cartCount.toString(),
//                   //           style: const TextStyle(
//                   //               fontSize: 11,
//                   //               fontWeight: FontWeight.w500,
//                   //               color: Colors.white),
//                   //         ),
//                   //       ),
//                   //     ),
//                   //   ),
//                 ],
//               ),
//               label: 'Cart',
//             ),
//             // BottomNavigationBarItem(
//             //   icon: Stack(
//             //     clipBehavior: Clip.none,
//             //     children: [
//             //       const Icon(Iconsax.save_2, size: 28),
//             //       if (wishlistCount > 0)
//             //         Positioned(
//             //           top: -5,
//             //           right: -5,
//             //           child: ScaleTransition(
//             //             scale: Tween<double>(begin: 0.7, end: 1.0).animate(
//             //               CurvedAnimation(
//             //                 parent: _animationController,
//             //                 curve: Curves.easeInOut,
//             //               ),
//             //             ),
//             //             child: CircleAvatar(
//             //               backgroundColor: alertColor,
//             //               radius: 10,
//             //               child: Text(
//             //                 wishlistCount.toString(),
//             //                 style: const TextStyle(
//             //                     fontSize: 10,
//             //                     fontWeight: FontWeight.w500,
//             //                     color: Colors.white),
//             //               ),
//             //             ),
//             //           ),
//             //         ),
//             //     ],
//             //   ),
//             //   label: 'Save',
//               BottomNavigationBarItem(
//               icon: Icon(Iconsax.save_2, size: 28),
//               label: 'History',
            
//             ),
//             const BottomNavigationBarItem(
//               icon: Icon(Iconsax.profile_circle4, size: 28),
//               label: 'Profile',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:apk_poli/home/histori_page.dart';
import 'package:apk_poli/home/home_page.dart';
import 'package:apk_poli/home/layanan_page.dart';
import 'package:apk_poli/home/profil_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Base extends StatefulWidget {
  final dynamic dataPasien;
  final String token;
  const Base({super.key, this.dataPasien, required this.token});

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  int currentIndex = 0;

  List<Widget> _buildScreens() {
    return [
      HomePage(dataPasien: widget.dataPasien),
      LayananPage(),
      //const Center(child: Text("Cart Page")), 
      HistoryPage(token: widget.token),
      ProfilePage(pasien: widget.dataPasien),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: currentIndex,
        children: _buildScreens(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 0,
        currentIndex: currentIndex,
        onTap: (int tab) {
          setState(() {
            currentIndex = tab;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home_14, size: 28),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.shop, size: 28),
            label: 'Layanan',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Iconsax.bag_2, size: 28),
          //   label: 'Cart',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.refresh_circle, size: 28),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.profile_circle4, size: 28),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
