import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'package:stedfasts_scheduler/common/platform_alert_dialog.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({
    @required String title,
    @required PlatformException exception,
  }) : super(
            title: title, content: exception.message, defaultActionsText: 'OK');

  // static String _message(PlatformException exception) {
  //   if (exception.message == 'FIRFirestoreErrorDomain') {
  //     if (exception.code == 'Error 7 ') {
  //       return 'Missing or insufficient permissions';
  //     }
  //   }
  //   return _errors[exception.code] ?? exception.message;
  // }

  // static Map<String, String> _errors = {
  //   ///  * `ERROR_WEAK_PASSWORD` - If the password is not strong enough.
  //   ///  * `ERROR_INVALID_EMAIL` - If the email address is malformed.
  //   ///  * `ERROR_EMAIL_ALREADY_IN_USE` - If the email is already in use by a different account.
  //   ///  * `ERROR_INVALID_EMAIL` - If the [email] address is malformed.
  //   'ERROR_WRONG_PASSWORD': "You have entered a wrong password"

  //   ///  * `ERROR_USER_NOT_FOUND` - If there is no user corresponding to the given [email] address, or if the user has been deleted.
  //   ///  * `ERROR_USER_DISABLED` - If the user has been disabled (for example, in the Firebase console)
  //   ///  * `ERROR_TOO_MANY_REQUESTS` - If there was too many attempts to sign in as this user.
  //   ///  * `ERROR_OPERATION_NOT_ALLOWED` - Indicates that Email & Password accounts are not enabled.
  // };
}
