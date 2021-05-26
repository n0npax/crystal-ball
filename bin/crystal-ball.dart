import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:crystal_ball/issue.dart';
import 'package:crystal_ball/check.dart';
import 'package:logging/logging.dart';

const regexOption = 'regex';
const issueNumberOption = 'issueNumber';
const orgOption = 'organization';
const repoNameOption = 'repository';
const commentFlag = 'comment';

final log = Logger('CLI');

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
      orgOption,
      help: '(required) organization or username',
      aliases: ['org', 'username', 'user'],
      abbr: 'o',
      valueHelp: 'organization or username',
      callback: (s) => requiredNotEmptyArg(s),
    );
    argParser.addOption(
      repoNameOption,
      help: '(required) repository name',
      aliases: ['repo'],
      abbr: 'r',
      valueHelp: 'repository name',
      callback: (s) => requiredNotEmptyArg(s),
    );

    // comment
    argParser.addFlag(
      commentFlag,
      abbr: 'c',
      defaultsTo: true,
      negatable: true,
    );
  }

  // [run] may also return a Future.
  @override
  void run() async {
    // [argResults] is set before [run()] is called and contains the flags/options
    // passed to this command.
    log.info(
        'processing issue num: ${argResults?[issueNumberOption]} repo: ${argResults?[repoNameOption]}/${argResults?[orgOption]}');
    var issue = Issue(
        org: argResults![orgOption],
        repoName: argResults![repoNameOption],
        number: argResults![issueNumberOption]);
    await issue.init();
    final failureReason = await isValidIssue(issue);
    print('::set-output name=commented::false');
    if (failureReason != '') {
      if (argResults![commentFlag]) {
        await issue.comment(
            ':crystal_ball: Crystal ball is not enough today :crystal_ball:,\n please update issue description.\n\nFailure reason:\n $failureReason');
        print('::set-output name=commented::true');
      }
    }
  }
}
