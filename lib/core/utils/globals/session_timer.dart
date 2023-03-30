import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:itpsm_mobile/core/utils/globals/globals.dart';
import 'package:itpsm_mobile/core/utils/log/get_logger.dart';
import 'package:logger/logger.dart';

class SessionTimer {
  static final Logger logger = getLogger();
  
  /// Starts the session timer 
  /// 
  /// The [expireDate] specifies how long the session will persist
  /// The [triggerLogoutEvent] holds a function triggering a [LogoutRequestedEvent]
  static void startTimer(DateTime expireDate, VoidCallback triggerLogoutEvent) {
    // If timer has not been initialized
    if(Globals.expirationTimer == null) {
      logger.d('Session timer initialized.');
      
      // Calculate the session length
      final timerDuration = expireDate.difference(DateTime.now());

      logger.d('Session duration: ${timerDuration.inMinutes} minutes.');

      Globals.expirationTimer = Timer.periodic(const Duration(seconds: 60), (timer) { 
        logger.d('${Globals.sessionLengthInMinutes} minutes has passed since the session began.');
        
        // If the session minute counter [Globals.sessionLengthInMinutes] has reached the length of the session
        if(Globals.sessionLengthInMinutes == timerDuration.inMinutes) {
          _showSessionAlert(false, triggerLogoutEvent: triggerLogoutEvent);
        }
        // If the session minute counter [Globals.sessionLengthInMinutes] is 5 minutes away from indicating the session expired
        else if((timerDuration.inMinutes - Globals.sessionLengthInMinutes).abs() == 5) {
          _showSessionAlert(true, minutes: 5);
        }

        Globals.sessionLengthInMinutes++;
      });
    }
    else {
      stopTimer();
    }
  }

  /// Resets [Globals.sessionLengthInMinutes] to 0 and cancels the timer [Globals.expirationTimer]
  static void stopTimer() {
    if(Globals.expirationTimer != null && Globals.expirationTimer!.isActive) {
      Globals.sessionLengthInMinutes = 0;
      Globals.expirationTimer!.cancel();
    }
  }

  /// Stops the session timer and also triggers the [LogoutRequestedEvent] inside the [triggerLogoutEvent] function
  static void _sessionExpired(VoidCallback triggerLogoutEvent) {
    stopTimer();
    triggerLogoutEvent();
  }


  /// Shows a dialog indicating whether the session will expire soon, if [isWarning] is true, or the session has expired if [isWarning] is false
  /// 
  /// The [minutes] is obligatory in case [isWarning] is true
  /// The [triggerLogoutEvent] is obligatory in case [isWarning] is false
  static Future<void> _showSessionAlert(bool isWarning, {int minutes = 0, VoidCallback? triggerLogoutEvent}) async {
    await showDialog(
      context: Globals.navigatorKey.currentState!.context, 
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            elevation: 6,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
            title: isWarning ? const Icon(Icons.alarm) : const Icon(Icons.warning_amber_rounded),
            actionsAlignment: MainAxisAlignment.center,
            content: isWarning ? 
            Text('Your session will expire in $minutes minutes!', textAlign: TextAlign.center)
            : const Text('Your session has expired!', textAlign: TextAlign.center),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(Globals.navigatorKey.currentState!.context).pop();

                  if(!isWarning) {
                    _sessionExpired(triggerLogoutEvent!); 
                  }
                },
                child: const Text('Aceptar')
              )
            ],
          ),
        ), 
      )
    );
  }
}