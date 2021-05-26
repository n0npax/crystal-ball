import './issue.dart';
import 'package:logging/logging.dart';

final log = Logger('checker');

Future<bool> isValidIssue(Issue issue) async {
  if (issue.body.isEmpty) {
    log.info('empty issue body');
    return false;
  }
  return true;
}
