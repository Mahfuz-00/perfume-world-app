import 'package:sqflite/sqflite.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../../Common/Bloc/employee_bloc.dart';
import '../../../Common/Bloc/profile_bloc.dart';
import '../../../Common/Bloc/project_bloc.dart';
import '../../../Common/Bloc/signout_bloc.dart';
import '../../../Common/Helper/local_database_helper.dart';
import '../../../Data/Repositories/activity_form_repositories_impl.dart';
import '../../../Data/Repositories/activity_repositories_impl.dart';
import '../../../Data/Repositories/attendance_form_repositories_impl.dart';
import '../../../Data/Repositories/attendance_repositories_impl.dart';
import '../../../Data/Repositories/dashboard_repositories_impl.dart';
import '../../../Data/Repositories/employee_repositories_impl.dart';
import '../../../Data/Repositories/head_of_accounts_repositories_impl.dart';
import '../../../Data/Repositories/leave_form_repositories_impl.dart';
import '../../../Data/Repositories/leave_repositories_impl.dart';
import '../../../Data/Repositories/profile_repositories_impl.dart';
import '../../../Data/Repositories/project_repositories_impl.dart';
import '../../../Data/Repositories/sign_in_repositories_impl.dart';
import '../../../Data/Repositories/signout_repositories_impl.dart';
import '../../../Data/Repositories/voucher_form_repositories_impl.dart';
import '../../../Data/Repositories/voucher_repositories_impl.dart';
import '../../../Data/Sources/activity_form_remote_source.dart';
import '../../../Data/Sources/attendance_form_remote_source.dart';
import '../../../Data/Sources/attendance_remote_source.dart';
import '../../../Data/Sources/dashboard_remote_source.dart';
import '../../../Data/Sources/employee_remote_source.dart';
import '../../../Data/Sources/head_of_accounts_remote_source.dart';
import '../../../Data/Sources/leave_form_remote_source.dart';
import '../../../Data/Sources/leave_remote_source.dart';
import '../../../Data/Sources/local_data_sources.dart';
import '../../../Data/Sources/profile_remote_source.dart';
import '../../../Data/Sources/project_remote_source.dart';
import '../../../Data/Sources/remote_data_sources.dart';
import '../../../Data/Sources/voucher_form_remote_source.dart';
import '../../../Data/Sources/voucher_remote_source.dart';
import '../../../Domain/Repositories/activity_form_repositories.dart';
import '../../../Domain/Repositories/attendance_form_repositories.dart';
import '../../../Domain/Repositories/attendance_repositories.dart';
import '../../../Domain/Repositories/dashboard_repositories.dart';
import '../../../Domain/Repositories/employee_repositories.dart';
import '../../../Domain/Repositories/head_of_accounts_repositories.dart';
import '../../../Domain/Repositories/leave_form_repositories.dart';
import '../../../Domain/Repositories/leave_repositories.dart';
import '../../../Domain/Repositories/profile_repositories.dart';
import '../../../Domain/Repositories/project_repositories.dart';
import '../../../Domain/Repositories/sign_in_repositories.dart';
import '../../../Domain/Repositories/activity_repositories.dart';
import '../../../Domain/Repositories/signout_repositories.dart';
import '../../../Domain/Repositories/voucher_form_repositories.dart';
import '../../../Domain/Repositories/voucher_repositories.dart';
import '../../../Domain/Usecases/activity_form_usercase.dart';
import '../../../Domain/Usecases/activity_usecases.dart';
import '../../../Domain/Usecases/attendance_form_usecase.dart';
import '../../../Domain/Usecases/attendance_usecase.dart';
import '../../../Domain/Usecases/dashboard_usecase.dart';
import '../../../Domain/Usecases/employee_usecase.dart';
import '../../../Domain/Usecases/head_of_accounts_usecase.dart';
import '../../../Domain/Usecases/leave_form_usecase.dart';
import '../../../Domain/Usecases/leave_usecase.dart';
import '../../../Domain/Usecases/profile_usecase.dart';
import '../../../Domain/Usecases/project_usecase.dart';
import '../../../Domain/Usecases/sign_in_usercases.dart';
import '../../../Domain/Usecases/signout_usecase.dart';
import '../../../Domain/Usecases/voucher_form_usecase.dart';
import '../../../Domain/Usecases/voucher_usecase.dart';
import '../../../Presentation/Activity Creation Page/Bloc/activity_form_bloc.dart';
import '../../../Presentation/Attendance Dashboard Page/Bloc/attendance_form_bloc.dart';
import '../../../Presentation/Dashboard Page/Bloc/dashboard_bloc.dart';
import '../../../Presentation/Leave Creation Page/Bloc/leave_form_bloc.dart';
import '../../../Presentation/Leave Dashboard Page/Bloc/leave_bloc.dart';
import '../../../Presentation/Voucher Creation Page/Bloc/headofaccounts_bloc.dart';
import '../../../Presentation/Voucher Creation Page/Bloc/voucher_form_bloc.dart';
import '../../../Presentation/Voucher Dashboard Page/Bloc/voucher_bloc.dart';

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
  getIt.registerLazySingleton(
      () => http.Client()); // HTTP client for making network requests.

  //Activity Dashboard
  // **4. Register DataSources**
  getIt.registerLazySingleton<LocalDataSource>(() => LocalDataSource(
      database)); // Local data source depends on the initialized database.
  getIt.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSource()); // Remote data source instance.

  // **5. Register Repositories**
  getIt.registerLazySingleton<ActivityRepository>(() => ActivityRepositoryImpl(
        getIt<RemoteDataSource>(), // Inject remote data source.
        getIt<LocalDataSource>(), // Inject local data source.
      ));

  // **6. Register UseCases**
  getIt.registerLazySingleton<ActivityUseCase>(() =>
      ActivityUseCase(getIt<ActivityRepository>())); // Fetch task use case.

  getIt.registerLazySingleton<SigninRepository>(
      () => SigninRepositoryImpl()); // Sign-in repository.

  // **7. Register SigninUseCase with its dependencies**
  getIt.registerLazySingleton<SigninUseCase>(
    () => SigninUseCase(
      getIt<SigninRepository>(), // Inject TokenRepository.
      getIt<RemoteDataSource>(), // Inject RemoteDataSource.
    ),
  );

  //Activity Form
  // **8. Register ActivityFormUseCase (first)**
  getIt.registerLazySingleton<ActivityFormUseCase>(
      () => ActivityFormUseCase(getIt())); // Create activity use case.

  // **9. Register ActivityFormBloc (depends on ActivityFormUseCase)**
  getIt.registerFactory(() => ActivityFormBloc(
      getIt<ActivityFormUseCase>())); // Inject the correct use case.

  // **10. Register Repository**
  getIt.registerLazySingleton<ActivityFormRepository>(
    () => ActivityFormRepositoryImpl(getIt()), // Inject activity repository.
  );

  // **12. Register Remote Sources**
  getIt.registerLazySingleton(() => ActivityFormRemoteDataSource(
      getIt())); // Activity remote data source depends on HTTP client.

  final client = http.Client();

  //Leave Form
  // Leave Form Dependencies
  getIt.registerLazySingleton<LeaveFormRemoteSource>(
    () => LeaveFormRemoteSource(getIt()),
  );

  getIt.registerLazySingleton<LeaveFormRepository>(
    () => LeaveFormRepositoryImpl(getIt<RemoteDataSource>()),
  );

  getIt.registerLazySingleton<SubmitLeaveFormUseCase>(
    () => SubmitLeaveFormUseCase(getIt<LeaveFormRepository>()),
  );

  getIt.registerFactory<LeaveFormBloc>(
    () =>
        LeaveFormBloc(submitLeaveFormUseCase: getIt<SubmitLeaveFormUseCase>()),
  );

  //Attendance Form Submission

  // Register AttendanceRemoteDataSourceImpl with Dio as a dependency
  getIt.registerLazySingleton<AttendanceFormRemoteDataSource>(
      () => AttendanceFormRemoteDataSource(getIt()));

  // Register AttendanceRepositoryImpl with RemoteDataSource
  getIt.registerLazySingleton<AttendanceFormRepository>(
      () => AttendanceFormRepositoryImpl(remoteDataSource: getIt()));

  // Register AttendanceUseCase with the repository
  getIt.registerLazySingleton(() => AttendanceFormUseCase(repository: getIt()));

  // Register AttendanceBloc with the use case
  getIt.registerFactory(
      () => AttendanceFormBloc(attendanceFormUseCase: getIt()));

  //Voucher Form Submission

  // Register Remote Data Source
  getIt.registerLazySingleton(() => VoucherFormRemoteDataSource(getIt()));

  // Register Repository
  getIt.registerLazySingleton<VoucherFormRepository>(
      () => VoucherFormRepositoryImpl(getIt()));

  // Register Use Case
  getIt.registerLazySingleton(() => SubmitVoucherFormUseCase(getIt()));

  // Register VoucherFormBloc with the use case
  getIt.registerFactory(() => VoucherFormBloc(
      submitVoucherFormUseCase: getIt<SubmitVoucherFormUseCase>()));

  //Profile
  getIt.registerLazySingleton<ProfileRemoteSource>(
      () => ProfileRemoteSourceImpl(client: getIt()));
  getIt.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(remoteSource: getIt()));
  getIt.registerLazySingleton<GetProfileUseCase>(
      () => GetProfileUseCase(repository: getIt()));
  getIt.registerFactory<ProfileBloc>(
      () => ProfileBloc(getProfileUseCase: getIt()));

  //Logout
  // Register SignOutRepository
  getIt.registerLazySingleton<SignOutRepository>(() => SignOutRepositoryImpl());

  // Register SignOutUseCase
  getIt.registerLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(signOutRepository: getIt<SignOutRepository>()));

  // Register SignOutBloc
  getIt.registerFactory<SignOutBloc>(
      () => SignOutBloc(signoutUseCase: getIt<SignOutUseCase>()));

  //Employee
  // Remote Data Source
  getIt.registerLazySingleton<EmployeeRemoteDataSource>(
    () => EmployeeRemoteDataSourceImpl(client: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use Case
  getIt.registerLazySingleton(() => GetEmployeesUseCase(repository: getIt()));

  // Bloc
  getIt.registerFactory<EmployeeBloc>(
    () => EmployeeBloc(getEmployeesUseCase: getIt<GetEmployeesUseCase>()),
  );

  //Project
  getIt.registerLazySingleton<ProjectRemoteDataSource>(
      () => ProjectRemoteDataSourceImpl(client: getIt()));
  getIt.registerLazySingleton<ProjectRepository>(
      () => ProjectRepositoryImpl(remoteDataSource: getIt()));
  getIt.registerLazySingleton<GetProjectsUseCase>(
      () => GetProjectsUseCase(repository: getIt()));
  getIt.registerFactory<ProjectBloc>(
      () => ProjectBloc(getProjectsUseCase: getIt()));

  //Head of Accounts
  // Data layer
  getIt.registerLazySingleton<ExpenseHeadRemoteDataSource>(
      () => ExpenseHeadRemoteDataSourceImpl(client: getIt()));

  getIt.registerLazySingleton<ExpenseHeadRepository>(
      () => ExpenseHeadRepositoryImpl(remoteDataSource: getIt()));

  // Domain layer
  getIt.registerLazySingleton(() => GetExpenseHeadsUseCase(getIt()));

  // Presentation layer
  getIt.registerFactory(() => ExpenseHeadBloc(getIt()));

  //Attendance Dashboard
  // Remote Data Source
  getIt.registerLazySingleton<AttendanceRemoteDataSource>(
    () => AttendanceRemoteDataSourceImpl(client: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use Case
  getIt.registerLazySingleton<GetAttendanceRequestsUseCase>(
    () => GetAttendanceRequestsUseCase(repository: getIt()),
  );

  //Leave Dashboard
  // Registering the remote source
  getIt.registerLazySingleton(() => LeaveRemoteSource(client: getIt()));

  // Repository
  getIt.registerLazySingleton<LeaveRepository>(
    () => LeaveRepositoryImpl(remoteSource: getIt()),
  );

  // UseCase
  getIt.registerLazySingleton(() => GetLeaveUseCase(repository: getIt()));

  // Bloc
  getIt.registerFactory(() => LeaveBloc(getLeaveApplicationsUseCase: getIt()));

  //Voucher Dashboard
  getIt.registerLazySingleton<VoucherRemoteDataSource>(
      () => VoucherRemoteDataSourceImpl(client: getIt()));
  getIt.registerLazySingleton<VoucherRepository>(
      () => VoucherRepositoryImpl(remoteDataSource: getIt()));
  getIt.registerLazySingleton(() => GetVouchers(repository: getIt()));
  getIt.registerFactory(() => VoucherBloc(getVouchers: getIt()));

  //Dashboard
  getIt.registerLazySingleton<DashboardRemoteSource>(
    () => DashboardRemoteSourceImpl(client: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(
    () => GetDashboardDataUseCase(repository: getIt()),
  );

  // Bloc
  getIt.registerFactory(
    () => DashboardBloc(getDashboardDataUseCase: getIt()),
  );
}
