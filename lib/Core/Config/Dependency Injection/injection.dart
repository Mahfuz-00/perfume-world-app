// lib/Core/Config/Dependency Injection/injection.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../../Common/Bloc/profile_bloc.dart';
import '../../../Common/Bloc/signout_bloc.dart';
import '../../../Common/Helper/local_database_helper.dart';
import '../../../Data/Repositories/customer_repositories_impl.dart';
import '../../../Data/Repositories/dashboard_repositories_impl.dart';
import '../../../Data/Repositories/invoice_repositories_impl.dart';
import '../../../Data/Repositories/payment_repositories_impl.dart';
import '../../../Data/Repositories/profile_repositories_impl.dart';
import '../../../Data/Repositories/sign_in_repositories_impl.dart';
import '../../../Data/Repositories/signout_repositories_impl.dart';
import '../../../Data/Sources/customer_remote_source.dart';
import '../../../Data/Sources/dashboard_remote_source.dart';
import '../../../Data/Sources/invoice_remote_source.dart';
import '../../../Data/Sources/local_data_sources.dart';
import '../../../Data/Sources/payment_remote_source.dart';
import '../../../Data/Sources/profile_remote_source.dart';
import '../../../Data/Sources/remote_data_sources.dart';
import '../../../Domain/Repositories/customer_repositories.dart';
import '../../../Domain/Repositories/dashboard_repositories.dart';
import '../../../Domain/Repositories/invoice_repositories.dart';
import '../../../Domain/Repositories/payment_repositories.dart';
import '../../../Domain/Repositories/profile_repositories.dart';
import '../../../Domain/Repositories/sign_in_repositories.dart';
import '../../../Domain/Repositories/signout_repositories.dart';
import '../../../Domain/Usecases/add_customer_usecase.dart';
import '../../../Domain/Usecases/dashboard_usecase.dart';
import '../../../Domain/Usecases/get_customer_usecase.dart';
import '../../../Domain/Usecases/payment_usecase.dart';
import '../../../Domain/Usecases/profile_usecase.dart';
import '../../../Domain/Usecases/sign_in_usercases.dart';
import '../../../Domain/Usecases/signout_usecase.dart';
import '../../../Domain/Usecases/submit_collection.dart';
import '../../../Domain/Usecases/submit_invoice.dart';
import '../../../Presentation/Dashboard Page/Bloc/customer_bloc.dart';
import '../../../Presentation/Dashboard Page/Bloc/dashboard_bloc.dart';
import '../../../Presentation/Dashboard Page/Bloc/invoice_bloc.dart';
import '../../../Presentation/Dashboard Page/Bloc/payment_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> init() async {
  // **1. Register database instance**
  final database = await DatabaseHelper.initializeDatabase();
  print("Database initialized: $database");

  if (database == null) {
    throw Exception("Database initialization failed");
  }

  // **2. Remove Duplicates**
  await DatabaseHelper.removeDuplicates();
  print("Duplicates removed");

  // **3. Print database structure and data for debugging**
  await DatabaseHelper.printDatabaseStructureAndData();

  // **11. Register External Dependencies**
  getIt.registerLazySingleton(() => http.Client());

  // Activity Dashboard
  // **4. Register DataSources**
  getIt.registerLazySingleton<LocalDataSource>(() => LocalDataSource(database));
  getIt.registerLazySingleton<RemoteDataSource>(() => RemoteDataSource());

  getIt.registerLazySingleton<SigninRepository>(() => SigninRepositoryImpl());

  // **7. Register SigninUseCase with its dependencies**
  getIt.registerLazySingleton<SigninUseCase>(
        () => SigninUseCase(
      getIt<SigninRepository>(),
      getIt<RemoteDataSource>(),
    ),
  );


  final client = http.Client();

  // Profile
  getIt.registerLazySingleton<ProfileRemoteSource>(() => ProfileRemoteSourceImpl(client: getIt()));
  getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(remoteSource: getIt()));
  getIt.registerLazySingleton<GetProfileUseCase>(() => GetProfileUseCase(repository: getIt()));
  getIt.registerFactory<ProfileBloc>(() => ProfileBloc(getProfileUseCase: getIt()));

  // Logout
  getIt.registerLazySingleton<SignOutRepository>(() => SignOutRepositoryImpl());

  getIt.registerLazySingleton<SignOutUseCase>(() => SignOutUseCase(signOutRepository: getIt<SignOutRepository>()));

  getIt.registerFactory<SignOutBloc>(() => SignOutBloc(signoutUseCase: getIt<SignOutUseCase>()));

  // Customer
  getIt.registerLazySingleton<CustomerRemoteDataSource>(
        () => CustomerRemoteDataSourceImpl(client: getIt<http.Client>()),
  );

  getIt.registerLazySingleton<CustomerRepository>(
        () => CustomerRepositoryImpl(remoteDataSource: getIt<CustomerRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetCustomers>(() => GetCustomers(getIt<CustomerRepository>()));

  getIt.registerLazySingleton<AddCustomer>(() => AddCustomer(getIt<CustomerRepository>()));

  getIt.registerFactory<CustomerBloc>(
        () => CustomerBloc(getIt<GetCustomers>(), getIt<AddCustomer>()),
  );

  //Invoice
  // Data sources
  getIt.registerLazySingleton<InvoiceRemoteDataSource>(
        () => InvoiceRemoteDataSourceImpl(client: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<InvoiceRepository>(
        () => InvoiceRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => SubmitInvoice(getIt()));
  getIt.registerLazySingleton(() => SubmitCollection(getIt()));

  // Blocs
  getIt.registerFactory(() => InvoiceBloc(getIt(), getIt()));

  // Dashboard
  getIt.registerLazySingleton<DashboardRemoteSource>(() => DashboardRemoteSourceImpl(client: getIt()));

  getIt.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(remoteSource: getIt()));

  getIt.registerLazySingleton(() => GetDashboardDataUseCase(repository: getIt()));

  getIt.registerFactory(() => DashboardBloc(getDashboardDataUseCase: getIt()));


  //Payment
  // Data sources
  getIt.registerLazySingleton<PaymentMethodRemoteDataSource>(
        () => PaymentMethodRemoteDataSourceImpl(
      client: getIt(),
    ),
  );

  // Repositories
  getIt.registerLazySingleton<PaymentMethodRepository>(
        () => PaymentMethodRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetPaymentMethods(getIt()));

  // Blocs
  getIt.registerFactory(() => PaymentMethodBloc(getPaymentMethods: getIt()));


}