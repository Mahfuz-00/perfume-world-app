part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DashboardInitialState extends DashboardState {}

class DashboardLoadingState extends DashboardState {}

class DashboardLoadedState extends DashboardState {
  final List<ProductEntity> dashboardData;

  DashboardLoadedState({required this.dashboardData});

  @override
  List<Object?> get props => [dashboardData];
}

class DashboardErrorState extends DashboardState {
  final String message;

  DashboardErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
