import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../Common/Bloc/profile_bloc.dart';
import '../../../Common/Bloc/signout_bloc.dart';
import '../../../Common/Helper/dimmed_overlay.dart';
import '../../../Common/Widgets/bottom_navigation_bar.dart';
import '../../../Common/Widgets/internet_connection_check.dart';
import '../../../Core/Config/Assets/app_images.dart';
import '../../../Core/Config/Theme/app_colors.dart';
import '../../../Data/Sources/dashboard_remote_source.dart';
import '../../../Domain/Entities/product_entities.dart';
import '../../Onboarding Page/Page/Onboarding_UI.dart';
import '../../Profile Page/Page/profile_UI.dart';
import '../Bloc/dashboard_bloc.dart';
import '../Widget/attendance_card.dart';
import '../Widget/cards.dart';
import '../Widget/leave_card.dart';
import '../Widget/meeting_card.dart';
import '../Widget/product_list.dart';
import '../Widget/task_card.dart';
import '../Widget/voucher_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    // Dispatch the event to fetch profile data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(FetchProfile());
      context.read<DashboardBloc>().add(LoadDashboardDataEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InternetConnectionChecker(
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoadingState) {
            Center(child: OverlayLoader());
          } else if (state is DashboardLoadedState) {
            return Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        color: AppColors.backgroundWhite,
                        padding: EdgeInsets.all(5),
                        height: screenHeight * 0.1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // BlocBuilder for Profile Details
                            BlocBuilder<ProfileBloc, ProfileState>(
                              builder: (context, state) {
                                if (state is ProfileLoading) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (state is ProfileLoaded) {
                                  final profile = state.profile;
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Name and Designation
                                      SizedBox(
                                        width: screenWidth * 0.55,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              // Name and Verified Icon
                                              Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      profile.name ?? 'N/A',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8.0),
                                                  Icon(
                                                    Icons.verified,
                                                    color: AppColors.primary,
                                                    size: screenWidth * 0.015,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              // Designation
                                              Text(
                                                profile.designation ?? 'N/A',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.primary,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Avatar
                                      GestureDetector(
                                        // onTap: () {
                                        //   // Navigate to user profile page
                                        //   Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //       builder: (context) => Profile(),
                                        //     ),
                                        //   );
                                        // },
                                      onTapDown: (details) => _showProfileDropdown(context, details.globalPosition),
                                        child: SizedBox(
                                          width: screenWidth * 0.1,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(8),
                                              child: profile.photoUrl != null
                                                  ? CachedNetworkImage(
                                                imageUrl:
                                                profile.photoUrl!,
                                                fit: BoxFit.cover,
                                                placeholder:
                                                    (context, url) =>
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .all(16.0),
                                                      child: OverlayLoader(),
                                                    ),
                                                errorWidget: (context,
                                                    url, error) =>
                                                    Container(
                                                      decoration:
                                                      BoxDecoration(
                                                        color: Colors
                                                            .grey.shade300,
                                                        shape:
                                                        BoxShape.circle,
                                                      ),
                                                      alignment:
                                                      Alignment.center,
                                                      child: Icon(
                                                        Icons.error,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                              )
                                                  : Image.asset(
                                                AppImages.ProfileImage,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (state is ProfileError) {
                                  return Center(
                                    child: Text('Error: ${state.message}'),
                                  );
                                }
                                return Container(
                                  color: AppColors.backgroundWhite,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              },
                            ),

                            SizedBox(width: 8),
                            // Cart Icon
                            GestureDetector(
                              onTap: () {
                                // Handle cart navigation (to be implemented)
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.backgroundGrey,
                                ),
                                child: Icon(
                                  Icons.shopping_cart,
                                  size: 20,
                                  color: AppColors.textAsh,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Perfume-World App
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ProductList(),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: SizedBox(
                height: screenHeight * 0.08,
                child: BottomNavBar(
                  containerHeight: screenHeight * 0.08,
                  currentPage: 'Home',
                ),
              ),
            );
          } else if (state is DashboardErrorState) {
            print('Dashboard Error: ${state.message}');
            return Center(child: Text('Error: ${state.message}'));
          }
          return Container(
              color: AppColors.backgroundWhite,
              child: Center(child: OverlayLoader()));
        },
      ),
    );
  }

  void _showProfileDropdown(BuildContext context, Offset tapPosition) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        tapPosition.dx,
        tapPosition.dy,
        overlay.size.width - tapPosition.dx,
        overlay.size.height - tapPosition.dy,
      ),
      items: [
        PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person, color: AppColors.primary),
              SizedBox(width: 8),
              Text('Profile', style: TextStyle(fontFamily: 'Roboto')),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'logout',
          child: BlocListener<SignOutBloc, SignOutState>(
            listener: (context, state) {
              if (state is SignOutLoading) {
                print('Signing out...');
              } else if (state is SignedOut) {
                print('Signed out successfully');
                Navigator.pushReplacement(
                  context,
                  _customPageRoute(OnboardingPage()),
                );
              } else if (state is SignOutError) {
                print('Error during sign out: ${state.error}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sign out failed: ${state.error}')),
                );
              }
            },
            child: Row(
              children: [
                Image.asset(
                  AppImages.LogoutIcon,
                  fit: BoxFit.cover,
                  width: 20,
                  height: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Logout',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: AppColors.textAsh,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ).then((value) {
      if (value == 'profile') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profile()),
        );
      } else if (value == 'logout') {
        context.read<SignOutBloc>().add(SignoutEvent());
      }
    });
  }

  // Define your custom page route with slide transition
  PageRouteBuilder _customPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Define the slide animation from the left
        const begin = Offset(1.0, 0.0); // Start off-screen on the left
        const end = Offset.zero; // End at the screen center
        const curve = Curves.easeInOut; // Smooth curve

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration:
      Duration(milliseconds: 500), // Duration of the transition
    );
  }

  SizedBox ActionIcons(double screenWidth, String imagepath) {
    return SizedBox(
      width: screenWidth * 0.05,
      child: Container(
        height: 65,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Ensures the container is circular
          color: AppColors.backgroundGrey, // Background color for the container
        ),
        child: ClipOval(
          // Ensures the image fits inside the circular container
          child: Image.asset(
            imagepath, // Replace with your image path
            fit: BoxFit.cover,
            // Ensures the image covers the container proportionally
            width: 35,
            // Match the height of the container
            height: 35, // Match the height of the container
          ),
        ),
      ),
    );
  }
}






