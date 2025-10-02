import 'dart:async';

import 'package:rick_and_morty/src/core/utils/refined_logger.dart';
import 'package:rick_and_morty/src/feature/initialization/logic/app_runner.dart';

void main() => runZonedGuarded(
      () => const AppRunner().initializeAndRun(),
      logger.logZoneError,
    );
