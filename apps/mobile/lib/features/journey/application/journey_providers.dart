import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/journey/application/journey_controller.dart';
import 'package:mobile/features/journey/application/journey_state.dart';

export 'journey_controller.dart';
export 'journey_state.dart';

final journeyControllerProvider =
    NotifierProvider<JourneyController, JourneyViewState>(
      JourneyController.new,
    );
