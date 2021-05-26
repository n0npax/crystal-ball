import './issue.dart';
import 'package:logging/logging.dart';
import 'dart:io';

final log = Logger('checker');

Future<List<String>> isValidIssue(Issue issue) async {
  // ignore: omit_local_variable_types
  List<String> reasons = [];
  Platform.environment.forEach((key, value) {
    if (key.startsWith('REGEX')) {
      final exp = RegExp(value, caseSensitive: false, multiLine: true);
      if (exp.hasMatch(issue.body)) {
        final regexpReason = '* RegExp `$value` has match';
        log.info(regexpReason);
        reasons.add(regexpReason);
      }
    }
  });

  if (issue.body.isEmpty) {
    const emptyReason = '* Empty issue description';
    log.info(emptyReason);
    reasons.add(emptyReason);
  }

  return reasons;
}
