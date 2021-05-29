// Import the test package and Counter class
import 'package:crystal_ball/check.dart';
import 'package:crystal_ball/issue.dart';
import 'package:test/test.dart';
import 'dart:io';

void main() {
  group('isValidIssue', () {
    test('Empty issue', () async {
      final issue = Issue(org: 'org', repoName: 'repoName', number: '1');
      final reasons = await isValidIssue(issue);
      expect(reasons.isNotEmpty, true);
    });
  });
  group('comment invalid issue', () {
    test('invalid issue #7 issue', () async {
      final issue = Issue(org: 'n0npax', repoName: 'crystal-ball', number: '7');
      await issue.init();
      final currentCommentsCnt = issue.commentsCnt;
      final testMsg = Platform.environment['GITHUB_REF'] ?? 'unknown';
      await issue.comment('Test comment. Origination ref: $testMsg');
      await issue.init();
      final newCommentsCnt = issue.commentsCnt;
      expect(newCommentsCnt - 1, equals(currentCommentsCnt));
    });
  });
}
