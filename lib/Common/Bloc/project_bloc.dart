import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../Domain/Entities/project_entities.dart';
import '../../Domain/Usecases/project_usecase.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final GetProjectsUseCase getProjectsUseCase;

  ProjectBloc({required this.getProjectsUseCase}) : super(ProjectInitial()) {
    on<LoadProjects>((event, emit) async {
      emit(ProjectLoading());
      try {
        final projects = await getProjectsUseCase.execute();
        emit(ProjectLoaded(projects: projects));
      } catch (e) {
        emit(ProjectError(error: e.toString()));
      }
    });
  }
}

