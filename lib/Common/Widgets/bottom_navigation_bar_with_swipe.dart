import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Core/Config/Assets/app_images.dart';
import '../../Core/Config/Theme/app_colors.dart';
import '../../Presentation/Activity Dashboard Page/Page/activity_dashboard_UI.dart';
import '../../Presentation/Dashboard Page/Page/dashboard_UI.dart';
import '../../Presentation/Leave Dashboard Page/Page/leave_dashboard_UI.dart';
import '../../Presentation/Voucher Dashboard Page/Page/voucher_dashboard_UI.dart';
import '../Bloc/bottom_navigation_with_swipe_cubit.dart';

class BottomNavBarWithSwipe extends StatefulWidget {
  final double containerHeight;
  final String currentPage;

  const BottomNavBarWithSwipe({
    Key? key,
    required this.containerHeight,
    required this.currentPage,
  }) : super(key: key);

  @override
  _BottomNavBarWithSwipeState createState() => _BottomNavBarWithSwipeState();
}

class _BottomNavBarWithSwipeState extends State<BottomNavBarWithSwipe> {
  late PageController _pageController;

  final List<String> _pageLabels = ['Home', 'Activity', 'Leave', 'Voucher'];
  final List<Widget> _pages = [
    Dashboard(),
    ActivityDashboard(),
    LeaveDashboard(),
    VoucherDashboard(),
  ];

  @override
  void initState() {
    super.initState();
    print("init state");
    int initialIndex = _pageLabels.indexOf(widget.currentPage);
    print('Initial index: $initialIndex');
    print('Current Page: ${widget.currentPage}');
    _pageController = PageController(initialPage: initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavBarCubit(_pageLabels.indexOf(widget.currentPage)),
      child: Scaffold(
        body: BlocBuilder<BottomNavBarCubit, int>(
          builder: (context, currentIndex) {
            return PageView(
              controller: _pageController,
              onPageChanged: (index) {
                context.read<BottomNavBarCubit>().setIndex(index);
              },
              children: _pages,
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<BottomNavBarCubit, int>(
          builder: (context, currentIndex) {
            return Container(
              color: AppColors.NavBarNavyBlue,
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: widget.containerHeight * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0; i < _pageLabels.length; i++)
                    _buildNavButton(
                      context,
                      currentIndex == i
                          ? _getFilledIcon(_pageLabels[i])
                          : _getDefaultIcon(_pageLabels[i]),
                      _pageLabels[i],
                      i,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavButton(
      BuildContext context,
      String imagePath,
      String label,
      int index,
      ) {
    return GestureDetector(
      onTap: () {
        context.read<BottomNavBarCubit>().setIndex(index);
        _pageController.jumpToPage(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 30.0,
            height: 30.0,
          ),
          const SizedBox(height: 8.0),
          Text(
            label,
            style: TextStyle(
              color: context.read<BottomNavBarCubit>().state == index
                  ? AppColors.textlightGreen
                  : Colors.white,
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }

  String _getFilledIcon(String pageName) {
    switch (pageName) {
      case 'Home':
        return AppImages.HomeFilledIcon;
      case 'Activity':
        return AppImages.ActivityFilledIcon;
      case 'Leave':
        return AppImages.LeaveFilledIcon;
      case 'Voucher':
        return AppImages.VoucherFilledIcon;
      default:
        return AppImages.HomeIcon;
    }
  }

  String _getDefaultIcon(String pageName) {
    switch (pageName) {
      case 'Home':
        return AppImages.HomeIcon;
      case 'Activity':
        return AppImages.ActivityIcon;
      case 'Leave':
        return AppImages.LeaveIcon;
      case 'Voucher':
        return AppImages.VoucherIcon;
      default:
        return AppImages.HomeIcon;
    }
  }
}

