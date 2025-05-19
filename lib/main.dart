import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Common/Bloc/bottom_navigation_with_swipe_cubit.dart';
import 'Common/Bloc/employee_bloc.dart';
import 'Common/Bloc/profile_bloc.dart';
import 'Common/Bloc/project_bloc.dart';
import 'Common/Bloc/signout_bloc.dart';
import 'Common/Helper/local_database_helper.dart';
import 'Core/Config/Dependency Injection/injection.dart';
import 'Core/Config/Theme/app_colors.dart';
import 'Data/Repositories/activity_repositories_impl.dart';
import 'Data/Sources/local_data_sources.dart';
import 'Data/Sources/remote_data_sources.dart';
import 'Domain/Usecases/activity_form_usercase.dart';
import 'Domain/Usecases/activity_usecases.dart';
import 'Domain/Usecases/sign_in_usercases.dart';
// import 'Presentation/Activity Creation Page/Bloc/activity_form_bloc.dart';
// import 'Presentation/Activity Dashboard Page/Bloc/activity_bloc.dart';
// import 'Presentation/Activity Dashboard Page/Bloc/activity_event.dart';
// import 'Presentation/Attendance Dashboard Page/Bloc/attendance_bloc.dart';
// import 'Presentation/Attendance Dashboard Page/Bloc/attendance_form_bloc.dart';
import 'Presentation/Dashboard Page/Bloc/cart_bloc.dart';
import 'Presentation/Dashboard Page/Bloc/dashboard_bloc.dart';
import 'Presentation/Dashboard Page/Page/dashboard_UI.dart';
import 'Core/Config/Dependency Injection/injection.dart' as di;

// import 'Presentation/Leave Creation Page/Bloc/leave_form_bloc.dart';
// import 'Presentation/Leave Dashboard Page/Bloc/leave_bloc.dart';
import 'Presentation/Onboarding Page/Page/Onboarding_UI.dart';
import 'Presentation/Sign In Page/Bloc/sign_in_bloc.dart';
// import 'Presentation/Voucher Creation Page/Bloc/headofaccounts_bloc.dart';
// import 'Presentation/Voucher Creation Page/Bloc/voucher_form_bloc.dart';
// import 'Presentation/Voucher Dashboard Page/Bloc/voucher_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  // Initialize dependencies
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Initialize the database and other dependencies
  Future<Widget> _initializeApp() async {

    print('Initializing');
    // Initialize the database
    final database = await DatabaseHelper.initializeDatabase();

    // Initialize the repositories
    final localDataSource = LocalDataSource(database);
    final remoteDataSource = RemoteDataSource();
    final taskRepository =
    ActivityRepositoryImpl(remoteDataSource, localDataSource);

    // Initialize the use case
    final fetchTasksUseCase = ActivityUseCase(taskRepository);

    return MaterialApp(
      title: 'Touch and Solve Inventory App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.containerBackgroundGrey300,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            onPrimary: AppColors.primary,
            background: AppColors.lightBackground),
        useMaterial3: true,
      ),
      home: OnboardingPage(),
      routes: {
        '/Home': (context) => Dashboard(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use FutureBuilder to handle async initialization
    return FutureBuilder<Widget>(
      future: _initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while the app is being initialized
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle errors if initialization fails
          return const Center(child: Text('Failed to load the app.'));
        } else {
          // Once everything is initialized, provide the TaskBloc to the app
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => BottomNavBarCubit(0)),
              // BlocProvider<ActivityBloc>(
              //   create: (context) {
              //     final fetchTasksUseCase =
              //     di.getIt<ActivityUseCase>(); // DI resolve here
              //     final taskBloc = ActivityBloc(fetchTasksUseCase);
              //     taskBloc.add(
              //         LoadActivityEvent()); // Add the event right after Bloc initialization
              //     return taskBloc;
              //   },
              // ),
              BlocProvider<SignInBloc>(
                create: (context) {
                  final loginUseCase = getIt<SigninUseCase>();
                  return SignInBloc(loginUseCase);
                },
              ),
              // BlocProvider<ActivityFormBloc>(
              //   create: (context) {
              //     final activityFormUseCase = getIt<ActivityFormUseCase>();
              //     return ActivityFormBloc(activityFormUseCase);
              //   },
              // ),
              // BlocProvider<LeaveFormBloc>(
              //   create: (context) => getIt<LeaveFormBloc>(),
              // ),
              // BlocProvider(
              //   create: (context) => getIt<AttendanceFormBloc>(),
              // ),
              // BlocProvider(
              //   create: (context) => getIt<VoucherFormBloc>(),
              // ),
              BlocProvider(
                create: (context) => getIt<ProfileBloc>(),
              ),
              BlocProvider<SignOutBloc>(
                create: (context) => getIt<SignOutBloc>(),
              ),
              BlocProvider(
                create: (context) =>
                getIt<EmployeeBloc>()..add(FetchEmployeesEvent()),
              ),
              BlocProvider(
                create: (context) => getIt<ProjectBloc>(),
              ),
              // BlocProvider(create: (_) => getIt<ExpenseHeadBloc>()),
              // BlocProvider(
              //   create: (_) => AttendanceBloc(
              //     getAttendanceRequestsUseCase: getIt(),
              //   ),
              // ),
              // BlocProvider(
              //   create: (_) => getIt<LeaveBloc>(),
              // ),
              // BlocProvider(
              //   create: (_) => getIt<VoucherBloc>()..add(FetchVouchersEvent()),
              // ),
              BlocProvider(
                create: (_) => getIt<DashboardBloc>()..add(LoadDashboardDataEvent()),
              ),
              BlocProvider(create: (context) => CartBloc()),
            ],
            child: snapshot.data!,
          );
        }
      },
    );
  }
}
