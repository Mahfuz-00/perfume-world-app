import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../Common/Bloc/profile_bloc.dart';
import '../../../Common/Bloc/signout_bloc.dart';
import '../../../Common/Helper/dimmed_overlay.dart';
import '../../../Common/Models/cart_model.dart';
import '../../../Common/Widgets/bottom_navigation_bar.dart';
import '../../../Common/Widgets/internet_connection_check.dart';
import '../../../Core/Config/Assets/app_images.dart';
import '../../../Core/Config/Theme/app_colors.dart';
import '../../../Data/Sources/dashboard_remote_source.dart';
import '../../../Domain/Entities/customer_entities.dart';
import '../../../Domain/Entities/product_entities.dart';
import '../../Onboarding Page/Page/Onboarding_UI.dart';
import '../../Profile Page/Page/profile_UI.dart';
import '../Bloc/cart_bloc.dart';
import '../Bloc/dashboard_bloc.dart';
import '../Widget/customer_search.dart';
import '../Widget/invoice_table.dart';
import '../Widget/product_list.dart';
import '../Widget/product_search.dart';
import '../Widget/zcspos.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Customer? _selectedCustomer;
  final Map<CartItem, double> _itemDiscounts = {};

  @override
  void initState() {
    super.initState();
    // Dispatch the event to fetch profile data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(FetchProfile());
      context.read<DashboardBloc>().add(LoadDashboardDataEvent());
    });
    ZCSPosSdk.initSdk(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    print('CartBloc available in Dashboard: ${context.read<CartBloc>()}');
    return InternetConnectionChecker(
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoadingState) {
            Center(child: CircularProgressIndicator());
          } else if (state is DashboardLoadedState) {
            return Scaffold(
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundWhite,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1), // Shadow color with slight opacity
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 2), // Shadow positioned below the bar
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(5),
                      height: screenHeight * 0.1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Logo and Perfume World
                          Flexible(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.TNSLogoLarge,
                                  width: screenWidth * 0.1,
                                  height: screenHeight * 0.05,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Perfume World',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Roboto',
                                    color: AppColors.primary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          // Existing right-side content
                          Row(
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
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // Name and Designation
                                        SizedBox(
                                          width: screenWidth * 0.55,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 1.0),
                                            child: Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                                  children: [
                                                    // Name and Verified Icon
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
                                                SizedBox(width: 8.0),
                                                Icon(
                                                  Icons.verified,
                                                  color: AppColors.primary,
                                                  size: screenWidth * 0.015,
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
                                                        child: CircularProgressIndicator(),
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
                              // BlocBuilder<CartBloc, CartState>(
                              //   builder: (context, cartState) {
                              //     int itemCount = cartState is CartUpdated ? cartState.cartItems.length : 0;
                              //     print('Cart items count: $itemCount');
                              //
                              //     return GestureDetector(
                              //       onTap: () {
                              //         // Handle cart navigation (to be implemented)
                              //       },
                              //       child: Stack(
                              //         alignment: Alignment.topRight,
                              //         children: [
                              //           Container(
                              //             padding: EdgeInsets.all(8),
                              //             decoration: BoxDecoration(
                              //               shape: BoxShape.circle,
                              //               color: AppColors.backgroundGrey,
                              //             ),
                              //             child: Icon(
                              //               Icons.shopping_cart,
                              //               size: 20,
                              //               color: AppColors.textAsh,
                              //             ),
                              //           ),
                              //           if (itemCount > 0)
                              //             Positioned(
                              //               right: 0,
                              //               top: 0,
                              //               child: Container(
                              //                 padding: EdgeInsets.all(4),
                              //                 decoration: BoxDecoration(
                              //                   shape: BoxShape.circle,
                              //                   color: AppColors.primary,
                              //                 ),
                              //                 child: Text(
                              //                   '$itemCount',
                              //                   style: TextStyle(
                              //                     fontSize: 10,
                              //                     color: AppColors.backgroundWhite,
                              //                     fontWeight: FontWeight.w600,
                              //                     fontFamily: 'Roboto',
                              //                   ),
                              //                 ),
                              //               ),
                              //             ),
                              //         ],
                              //       ),
                              //     );
                              //   },
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //Perfume-World App
                    Expanded(
                      child: Container(
                        color: AppColors.backgroundWhite.withOpacity(0.8),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            print('Available height: ${constraints.maxHeight}');
                            return BlocBuilder<DashboardBloc, DashboardState>(
                              builder: (context, state) {
                                if (state is DashboardLoadingState) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (state is DashboardErrorState) {
                                  print('Dashboard Error: ${state.message}');
                                  return Center(child: Text('Error: ${state.message}'));
                                }
                                final List<ProductEntity> products = state is DashboardLoadedState
                                    ? state.dashboardData
                                    : [];
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Left Part: Product Search and List
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            // SizedBox(height: 16),
                                            Expanded(
                                              child: SingleChildScrollView(child: ProductList(products: products)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Right Part: Customer Search, Invoice Table, Inputs
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 16, bottom: 8),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustomerSearchWidget(
                                                onCustomerSelected: (customer) {
                                                  setState(() {
                                                    _selectedCustomer = customer;
                                                    print('Selected: $customer');
                                                  });
                                                },
                                              ),
                                              SizedBox(height: 8),
                                              InvoiceTableWidget(
                                                onDiscountChanged: (item, discount) {
                                                  setState(() {
                                                    _itemDiscounts[item] = discount;
                                                  });
                                                },
                                                itemDiscounts: _itemDiscounts,
                                                selectedCustomer: _selectedCustomer,
                                              ),
                                              SizedBox(height: 16),
                                              // InvoiceInputsWidget(itemDiscounts: _itemDiscounts),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: state is DashboardLoadingState
                    //       ? Center(child: CircularProgressIndicator())
                    //       : state is DashboardLoadedState
                    //       ? ProductList(products: state.dashboardData as List<ProductEntity>)
                    //       : state is DashboardErrorState
                    //       ? Center(child: Text('Error: No Product Found'))
                    //       : SizedBox.shrink(),
                    // ),
                  ],
                ),
              ),
            );
          } else if (state is DashboardErrorState) {
            print('Dashboard Error: ${state.message}');
            return Center(child: Text('Error: ${state.message}'));
          }
          return Container(
              color: AppColors.backgroundWhite,
              child: Center(child: CircularProgressIndicator()));
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
        // PopupMenuItem(
        //   value: 'profile',
        //   child: Row(
        //     children: [
        //       Icon(Icons.person, color: AppColors.primary),
        //       SizedBox(width: 8),
        //       Text('Profile', style: TextStyle(fontFamily: 'Roboto')),
        //     ],
        //   ),
        // ),
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
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => Profile()),
        // );
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