import 'package:crystal_ball/issue.dart';
import 'package:test/test.dart';
import 'dart:io';

void main() {
  group('invalid issue #7', () {
    test('comment', () async {
      final issue = Issue(org: 'n0npax', repoName: 'crystal-ball', number: '7');
      await issue.init();
      final currentCommentsCnt = issue.commentsCnt;
      final testMsg = Platform.environment['GITHUB_REF'] ?? 'unknown';
      await issue.comment('Test comment. Origination ref: $testMsg');
      await issue.init();
      final newCommentsCnt = issue.commentsCnt;
      expect(newCommentsCnt - 1, equals(currentCommentsCnt));
    });
    test('label', () async {
      final issue = Issue(org: 'n0npax', repoName: 'crystal-ball', number: '7');
      await issue.init();
      final startLabels = issue.labels;
      await issue.addLabels(['foo']);
      await issue.init();
      final updatedLabels = issue.labels;
      await issue.rmLabels(['foo']);
      await issue.init();
      final finalFabels = issue.labels;
      expect(updatedLabels.length - 1, startLabels.length);
      expect(finalFabels.length, startLabels.length);
    });
  });
}
