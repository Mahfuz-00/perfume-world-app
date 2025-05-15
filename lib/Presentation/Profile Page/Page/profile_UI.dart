import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Common/Bloc/profile_bloc.dart';
import '../../../Common/Bloc/signout_bloc.dart';
import '../../../Common/Helper/dimmed_overlay.dart';
import '../../../Common/Widgets/appbar_model.dart';
import '../../../Common/Widgets/bottom_navigation_bar.dart';
import '../../../Common/Widgets/internet_connection_check.dart';
import '../../../Core/Config/Assets/app_images.dart';
import '../../../Core/Config/Theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../Onboarding Page/Page/Onboarding_UI.dart';
import 'faq_UI.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    // Dispatch the event to fetch profile data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(FetchProfile());
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return InternetConnectionChecker(
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Container(
                color: AppColors.textWhite,
                child: Center(child: OverlayLoader()));
          } else if (state is ProfileLoaded) {
            final profile = state.profile;

            print('Profile Name: ${profile.name}');
            print('Profile Email: ${profile.email}');
            print('Profile Phone Number: ${profile.phoneNumber}');
            print('Profile Photo URL: ${profile.photoUrl}');
            print('Profile Designation: ${profile.designation}');
            print('Profile Department: ${profile.department}');
            print('Profile Employee ID: ${profile.employeeID}');

            return Scaffold(
              appBar:
                  AppBarModel(title: 'My Profile', color: AppColors.primary),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: AppColors.primary,
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height,
                        minWidth: MediaQuery.of(context).size.width,
                      ),
                      child: Stack(
                        children: [
                          // Container 2: Positioned over Container 1
                          Container(
                            child: Container(
                              width: screenWidth,
                              margin: EdgeInsets.only(top: screenHeight * 0.1),
                              padding: EdgeInsets.only(top: 75),
                              height: screenHeight - screenHeight * 0.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                color: AppColors.backgroundWhite,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            profile.name,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Roboto',
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          SizedBox(width: 8.0),
                                          Icon(
                                            Icons.verified,
                                            color: AppColors.primary,
                                            size: screenWidth * 0.05,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    // Designation text
                                    Center(
                                      child: Text(
                                        profile.designation,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          color: AppColors.primary,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    // First Container: User Details
                                    Text(
                                      'Contact',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Roboto',
                                          color: AppColors.textDarkGrey),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: AppColors
                                            .containerBackgroundGrey400,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                AppImages.ProfileIcon2,
                                                fit: BoxFit.cover,
                                                width: 20,
                                                height: 20,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                profile.phoneNumber,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Roboto',
                                                    color: AppColors.textAsh),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Image.asset(
                                                AppImages.EmailFilledIcon,
                                                fit: BoxFit.cover,
                                                width: 20,
                                                height: 20,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                profile.email,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Roboto',
                                                    color: AppColors.textAsh),
                                              ),
                                            ],
                                          ),
                                          /*SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  AppImages.LocationIcon,
                                                  fit: BoxFit.cover,
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  'New York',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400,
                                                      fontFamily: 'Roboto',
                                                      color: AppColors.textAsh),
                                                ),
                                              ],
                                            ),*/
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 20),

                                    // Second Container: Settings Options
                                    Text(
                                      'Settings',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Roboto',
                                          color: AppColors.textDarkGrey),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: AppColors
                                            .containerBackgroundGrey400,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                AppImages.ChangePasswordIcon,
                                                fit: BoxFit.cover,
                                                width: 20,
                                                height: 20,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                'Change Password',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Roboto',
                                                    color: AppColors.textAsh),
                                              ),
                                              Spacer(),
                                              Icon(Icons.arrow_forward_ios,
                                                  color: AppColors.primary,
                                                  size: 16),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          GestureDetector(
                                            onTap: () {
                                              print('FAQ Button Pressed');
                                              Navigator.push(
                                                context,
                                                _customPageRoute(FAQ()),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  AppImages.FAQIcon,
                                                  fit: BoxFit.cover,
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  'FAQ & Help',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: 'Roboto',
                                                      color: AppColors.textAsh),
                                                ),
                                                Spacer(),
                                                Icon(Icons.arrow_forward_ios,
                                                    color: AppColors.primary,
                                                    size: 16),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          BlocListener<SignOutBloc,
                                              SignOutState>(
                                            listener: (context, state) {
                                              if (state is SignOutLoading) {
                                                print('Signing out...');
                                              } else if (state is SignedOut) {
                                                print(
                                                    'Signed out successfully');
                                                // Navigate to the sign-in page
                                                Navigator.pushReplacement(
                                                  context,
                                                  _customPageRoute(
                                                      OnboardingPage()),
                                                );
                                              } else if (state
                                                  is SignOutError) {
                                                print(
                                                    'Error during sign out: ${state.error}');
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          'Sign out failed: ${state.error}')),
                                                );
                                              }
                                            },
                                            child: GestureDetector(
                                              onTap: () {
                                                print(
                                                    'Sign Out Button Pressed');
                                                // When logout is pressed, dispatch the Logout event
                                                context
                                                    .read<SignOutBloc>()
                                                    .add(SignoutEvent());
                                              },
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    AppImages.LogoutIcon,
                                                    fit: BoxFit.cover,
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    'Logout',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily: 'Roboto',
                                                        color:
                                                            AppColors.textAsh),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Profile image section
                          Center(
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.primary,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 5,
                                ),
                              ),
                              margin:
                                  EdgeInsets.only(top: screenHeight * 0.1 - 75),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: profile.photoUrl != null
                                    ? CachedNetworkImage(
                                        imageUrl: profile.photoUrl!,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      )
                                    : Image.asset(
                                        AppImages.ProfileImage,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: SizedBox(
                height: screenHeight * 0.08,
                child: BottomNavBar(
                  containerHeight: screenHeight * 0.08,
                  currentPage: '',
                ),
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return Container(); // Default empty container if no state
        },
      ),
    );
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
}
