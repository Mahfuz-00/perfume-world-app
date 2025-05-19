// import 'package:flutter/material.dart';
//
// import '../../Core/Config/Assets/app_images.dart';
// import '../../Core/Config/Theme/app_colors.dart';
// import '../../Presentation/Activity Dashboard Page/Page/activity_dashboard_UI.dart';
// import '../../Presentation/Attendance Dashboard Page/Page/attendance_dashboard_UI.dart';
// import '../../Presentation/Dashboard Page/Page/dashboard_UI.dart';
// import '../../Presentation/Leave Dashboard Page/Page/leave_dashboard_UI.dart';
// import '../../Presentation/Voucher Dashboard Page/Page/voucher_dashboard_UI.dart';
// import '../Helper/navigation_transition.dart';
//
// class BottomNavBar extends StatelessWidget {
//   final double containerHeight;
//   final String currentPage;
//
//   const BottomNavBar(
//       {Key? key, required this.containerHeight, required this.currentPage})
//       : super(key: key);
//
//   // Function to handle the onPressed for each button
//   void _onButtonPressed(BuildContext context, String pageName) {
//     if (pageName == currentPage) return;
//
//     // Define the custom page route animation
//     /*PageRouteBuilder _customPageRoute(Widget page) {
//       return PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) => page,
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           // Define the slide animation from the left
//           const begin = Offset(1.0, 0.0); // Start off-screen on the left
//           const end = Offset.zero; // End at the screen center
//           const curve = Curves.easeInOut; // Smooth curve
//
//           var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//           var offsetAnimation = animation.drive(tween);
//
//           return SlideTransition(position: offsetAnimation, child: child);
//         },
//         transitionDuration: Duration(milliseconds: 50), // Duration of the transition
//       );
//     }*/
//
//     switch (pageName) {
//       case 'Home':
//         Navigator.push(
//           context,
//           customPageRoute(Dashboard()),
//           // _customPageRoute(Dashboard()),
//         );
//         break;
//       case 'Activity':
//         Navigator.push(
//           context,
//           customPageRoute(ActivityDashboard()),
//           //_customPageRoute(ActivityDashboard()),
//         );
//         break;
//       case 'Attendance':
//         Navigator.push(
//           context,
//           customPageRoute(AttendanceDashboard()),
//           //_customPageRoute(AttendanceDashboard()),
//         );
//         break;
//       case 'Leave':
//         Navigator.push(
//           context,
//           customPageRoute(LeaveDashboard()),
//           //_customPageRoute(LeaveDashboard()),
//         );
//         break;
//       case 'Voucher':
//         Navigator.push(
//           context,
//           customPageRoute(VoucherDashboard()),
//          // _customPageRoute(VoucherDashboard()),
//         );
//         break;
//       default:
//         print('Unknown page: $pageName');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppColors.NavBarNavyBlue,
//       padding: EdgeInsets.symmetric(
//         horizontal: MediaQuery.of(context).size.width * 0.05,
//         vertical: containerHeight * 0.02,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _buildNavButton(
//               context,
//               currentPage == 'Home'
//                   ? AppImages.HomeFilledIcon
//                   : AppImages.HomeIcon,
//               'Home'),
//           _buildNavButton(
//               context,
//               currentPage == 'Activity'
//                   ? AppImages.ActivityFilledIcon
//                   : AppImages.ActivityIcon,
//               'Activity'),
//           _buildNavButton(
//               context,
//               currentPage == 'Attendance'
//                   ? AppImages.AttendanceFilledIcon
//                   : AppImages.AttendanceIcon,
//               'Attendance'),
//           _buildNavButton(
//               context,
//               currentPage == 'Leave'
//                   ? AppImages.LeaveFilledIcon
//                   : AppImages.LeaveIcon,
//               'Leave'),
//           _buildNavButton(
//               context,
//               currentPage == 'Voucher'
//                   ? AppImages.VoucherFilledIcon
//                   : AppImages.VoucherIcon,
//               'Voucher'),
//         ],
//       ),
//     );
//   }
//
//   // Helper method to create individual buttons
//   Widget _buildNavButton(BuildContext context, String imagePath, String label) {
//     return GestureDetector(
//       onTap: () => _onButtonPressed(context, label), // Trigger action on tap
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset(
//             imagePath, // Pass the image path here
//             width: 30.0, // Adjust image size as needed
//             height: 30.0, // Adjust image size as needed
//           ),
//           const SizedBox(height: 8.0),
//           Text(
//             label,
//             style: TextStyle(
//                 color: AppColors.textlightGreen,
//                 // You can customize the label color here
//                 fontSize: 12.0,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: 'Roboto'),
//           ),
//         ],
//       ),
//     );
//   }
// }
