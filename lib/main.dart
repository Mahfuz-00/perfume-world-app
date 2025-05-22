import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Common/Bloc/profile_bloc.dart';
import 'Common/Bloc/signout_bloc.dart';
import 'Common/Helper/local_database_helper.dart';
import 'Core/Config/Dependency Injection/injection.dart';
import 'Core/Config/Theme/app_colors.dart';
import 'Data/Sources/customer_remote_source.dart';
import 'Data/Sources/local_data_sources.dart';
import 'Data/Sources/remote_data_sources.dart';
import 'Domain/Repositories/customer_repositories.dart';
import 'Domain/Usecases/sign_in_usercases.dart';
import 'Presentation/Dashboard Page/Bloc/cart_bloc.dart';
import 'Presentation/Dashboard Page/Bloc/customer_bloc.dart';
import 'Presentation/Dashboard Page/Bloc/dashboard_bloc.dart';
import 'Presentation/Dashboard Page/Bloc/invoice_bloc.dart';
import 'Presentation/Dashboard Page/Bloc/invoice_print_bloc.dart';
import 'Presentation/Dashboard Page/Bloc/payment_bloc.dart';
import 'Presentation/Dashboard Page/Bloc/payment_event.dart';
import 'Presentation/Dashboard Page/Page/dashboard_UI.dart';
import 'Core/Config/Dependency Injection/injection.dart' as di;
import 'Presentation/Onboarding Page/Page/Onboarding_UI.dart';
import 'Presentation/Sign In Page/Bloc/sign_in_bloc.dart';

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
              BlocProvider<SignInBloc>(
                create: (context) {
                  final loginUseCase = getIt<SigninUseCase>();
                  return SignInBloc(loginUseCase);
                },
              ),
              BlocProvider(
                create: (context) => getIt<ProfileBloc>(),
              ),
              BlocProvider<SignOutBloc>(
                create: (context) => getIt<SignOutBloc>(),
              ),
              BlocProvider(
                create: (_) => getIt<DashboardBloc>()..add(LoadDashboardDataEvent()),
              ),
              BlocProvider(create: (context) => CartBloc()),
              BlocProvider(create: (_) => di.getIt<CustomerBloc>(),),
              BlocProvider(create: (_) => di.getIt<InvoiceBloc>(),),
              BlocProvider(create: (_) => InvoicePrintBloc()),
              BlocProvider(
                create: (_) => di.getIt<PaymentMethodBloc>()..add(FetchPaymentMethods()),
              ),
            ],
            child: snapshot.data!,
          );
        }
      },
    );
  }
}
