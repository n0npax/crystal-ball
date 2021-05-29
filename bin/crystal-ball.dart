import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:crystal_ball/issue.dart';
import 'package:crystal_ball/check.dart';
import 'package:logging/logging.dart';

const regexOption = 'regex';
const issueNumberOption = 'issueNumber';
const repositoryOption = 'repository';
const commentFlag = 'comment';
const labelOption = 'label';

final log = Logger('CLI');
final defaultCommentMessage =
    ':crystal_ball::crystal_ball::crystal_ball::crystal_ball:'
    ':crystal_ball::crystal_ball::crystal_ball::crystal_ball::crystal_ball:'
    '\nSeems like issue doesn\'t meet all standards\n---\n'
    'Please update issue description.';
final commentMessage = () {
  final envValue = Platform.environment['COMMENT_MSG'];
  if (envValue?.isEmpty ?? true) {
    return defaultCommentMessage;
  }
  return envValue;
}();

void main(List<String> args) {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.loggerName}: ${record.message}');
  });

  final runner =
      CommandRunner('crystal-ball', 'check if crystal ball is required')
        ..addCommand(IssueCommand())
        ..run(args);
}

class IssueCommand extends Command {
  @override
  final name = 'check';
  @override
  final description = 'check if issue requires crystal ball';

  void requiredNotEmptyArg(String? s) {
    if (s?.isEmpty ?? true) {
      printUsage();
      exit(2);
    }
    ;
  }

  void requiredRepoArg(String? s) {
    if (s?.isEmpty ?? true) {
      printUsage();
      exit(2);
    }
    final r = s!.split('/');
    if (r.length != 2) {
      printUsage();
      exit(2);
    }
  }

  IssueCommand() {
    argParser.addOption(
      issueNumberOption,
      help: '(required) github issue number',
      aliases: ['num', 'number'],
      abbr: 'n',
      valueHelp: 'issue number',
      allowedHelp: {'https://github.com/n0npax/crystal-ball/issues/1': '1'},
      callback: (s) => requiredNotEmptyArg(s),
    );
    argParser.addOption(
      repositoryOption,
      help: '(required) repository (org/repo form)',
      aliases: ['repo'],
      abbr: 'r',
      valueHelp: 'org/repoName',
      callback: (s) => requiredRepoArg(s),
    );

    // actions
    argParser.addFlag(
      commentFlag,
      abbr: 'c',
      defaultsTo: true,
      negatable: true,
    );

    argParser.addOption(
      labelOption,
      help: 'labels to put on issue. Separated by comma',
      aliases: ['lab'],
      abbr: 'l',
      valueHelp: 'example label,label2',
    );
  }

  @override
  void run() async {
    log.info('processing issue num: ${argResults?[issueNumberOption]}'
        ' repo: ${argResults?[repositoryOption]}');
    var issue = Issue(
        org: argResults![repositoryOption].split('/')[0],
        repoName: argResults![repositoryOption].split('/')[1],
        number: argResults![issueNumberOption]);
    await issue.init();
    final failureReason = await isValidIssue(issue);
    final labels = argResults![labelOption].split(',');
    if (failureReason.isNotEmpty) {
      if (!labels.isEmpty) {
        await issue.addLabels(labels);
      }
      if (argResults![commentFlag]) {
        await issue.comment(
            '$commentMessage \n\nFailure reason:\n${failureReason.join('\n')}');
        print('::set-output name=commented::true');
      } else {
        print('::set-output name=commented::false');
      }
    } else {
      await issue.rmLabels(labels);
    }
  }
}
