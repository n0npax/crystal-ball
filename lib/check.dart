import './issue.dart';
import 'package:logging/logging.dart';
import 'dart:io';

final log = Logger('checker');

/// Determines if GitHub issue is valid
///
/// Returns list of reasons why issue is not valid
Future<List<String>> isValidIssue(Issue issue) async {
  // ignore: omit_local_variable_types
  List<String> reasons = [];
  Platform.environment.forEach((key, value) {
    if (key.startsWith('CRYSTAL_MATCH_REGEX')) {
      final exp = RegExp(value, caseSensitive: false, multiLine: true);
      if (!exp.hasMatch(issue.body)) {
        final regexpReason = '* RegExp `$value` has no match';
        log.info(regexpReason);
        reasons.add(regexpReason);
      }
    }
    if (key.startsWith('CRYSTAL_NOMATCH_REGEX')) {
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
