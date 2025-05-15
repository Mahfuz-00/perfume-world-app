import '../Entities/activity_form_entities.dart';
import '../Repositories/activity_form_repositories.dart';

class ActivityFormUseCase {
  final ActivityFormRepository repository;

  ActivityFormUseCase(this.repository);

  Future<void> call(ActivityFromEntity activity) {
    return repository.createActivity(activity);
  }
}
