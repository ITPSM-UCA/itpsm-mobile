import 'dart:async';

import 'package:flutter/widgets.dart';

class Globals {
  static Timer? expirationTimer;
  static int sessionLengthInMinutes = 0;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}