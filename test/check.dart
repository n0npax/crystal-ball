// Import the test package and Counter class
import 'package:test/test.dart';
import '../lib/check.dart';
import '../lib/issue.dart';

void main() {
  group('isValidIssue', () {
    test('Empty issue', () async {
      final issue = Issue(org: 'org', repoName: 'repoName', number: '1');
      final reasons = await isValidIssue(issue);

      expect(reasons.isNotEmpty, true);
    });
  });
}
