import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:perfume_world_app/Domain/Entities/product_entities.dart';

import '../../../Domain/Entities/dashboard_entities.dart';
import '../../../Domain/Usecases/dashboard_usecase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardDataUseCase getDashboardDataUseCase;

  DashboardBloc({required this.getDashboardDataUseCase}) : super(DashboardInitialState()) {
    on<LoadDashboardDataEvent>((event, emit) async {
      emit(DashboardLoadingState());
      try {
        final data = await getDashboardDataUseCase();
        emit(DashboardLoadedState(dashboardData: data));
      } catch (e) {
        emit(DashboardErrorState(message: e.toString()));
      }
    });
  }
}
