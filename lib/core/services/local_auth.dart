





import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';


import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuth {
  static final _auth = LocalAuthentication();

  static Future<bool> _canAuthenticate() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  static Future<bool> authenticate() async {
    try {
      if (!await _canAuthenticate()) return false;

      return await _auth.authenticate(
        authMessages: [
          AndroidAuthMessages(
            signInTitle: 'Sign in',
            cancelButton: 'No Thanks',
          ),
          IOSAuthMessages(
            cancelButton: 'No thanks',
          ),
        ],
        localizedReason: 'Use Face ID to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      debugPrint('error $e');
      return false;
    }
  }
}



// import 'package:local_auth/local_auth.dart';

// class LocalAuth{
//   static final _auth = LocalAuthentication();

//   static Future<bool>_canAuthenticate()async=>
//   await _auth.canCheckBiometrics || _auth.isDeviceSupported();

//   static Future<bool> authenticate() async{
//     try{
//       if(!await _canAuthenticate()) return false;

//       return await _auth.authenticate(
//         authMessages: [
//           AndroidAuthMessages(
//             singInTitle: 'Sign in',
//             cancelButton: 'No Thanks',
//           ),
//           IOSAuthMessages(
//             cancelButton: 'No thanks',
//           ),
//         ],
//         localizedReason: 'Use Face Id to Authenticate',
//         options: const AuthenticationOptions(
//           useErrorDialogs: true,
//           stickyAuth: true,
//         )
//       );

//     }catch (e) {
//       debugPrint('error $e');
//       return false;
//     }

//   }

// } 