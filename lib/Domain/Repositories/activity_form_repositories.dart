import '../Entities/activity_form_entities.dart';

abstract class ActivityFormRepository {
  Future<void> createActivity(ActivityFromEntity activity);
}
