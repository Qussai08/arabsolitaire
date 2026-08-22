import 'package:mobile/features/journey/domain/journey_models.dart';

abstract interface class JourneyRepository {
  Future<JourneyProgress> loadProgress();
  Future<void> saveProgress(JourneyProgress progress);
  Future<PlayerLocalFlags> loadFlags();
  Future<void> saveFlags(PlayerLocalFlags flags);
}
