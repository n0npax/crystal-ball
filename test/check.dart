import 'package:crystal_ball/check.dart';
import 'package:crystal_ball/issue.dart';
import 'package:test/test.dart';

void main() {
  group('isValidIssue', () {
    test('Empty issue', () async {
      final issue = Issue(org: 'org', repoName: 'repoName', number: '1');
      final reasons = await isValidIssue(issue);
      expect(reasons.isNotEmpty, true);
    });
  });
}
