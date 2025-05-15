part of 'project_bloc.dart';

abstract class ProjectState {}

class ProjectInitial extends ProjectState {}

class ProjectLoading extends ProjectState {}

class ProjectLoaded extends ProjectState {
  final List<ProjectEntity> projects;

  ProjectLoaded({required this.projects});
}

class ProjectError extends ProjectState {
  final String error;

  ProjectError({required this.error});
}
