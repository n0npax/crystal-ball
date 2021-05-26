import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:crystal_ball/issue.dart';
import 'package:crystal_ball/check.dart';
import 'package:logging/logging.dart';

const regex = 'regex';
const issueNumber = 'issueNumber';
const org = 'organization';
const repoName = 'repository';

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
      issueNumber,
      help: '(required) github issue number',
      aliases: ['num', 'number'],
      abbr: 'n',
      valueHelp: 'issue number',
      allowedHelp: {'https://github.com/n0npax/crystal-ball/issues/1': '1'},
      callback: (s) => requiredNotEmptyArg(s),
    );
    argParser.addOption(
      org,
      help: '(required) organization or username',
      aliases: ['org', 'username', 'user'],
      abbr: 'o',
      valueHelp: 'organization or username',
      callback: (s) => requiredNotEmptyArg(s),
    );
    argParser.addOption(
      repoName,
      help: '(required) repository name',
      aliases: ['repo'],
      abbr: 'r',
      valueHelp: 'repository name',
      callback: (s) => requiredNotEmptyArg(s),
    );

    // regexp
    argParser.addMultiOption(
      regex,
      help: 'regular expresions to trigger crystal ball comment',
      aliases: ['regexp'],
      abbr: 'x',
      valueHelp: 'regural expression',
    );
  }

  // [run] may also return a Future.
  @override
  void run() async {
    // [argResults] is set before [run()] is called and contains the flags/options
    // passed to this command.
    log.info(
        'processing issue num: ${argResults?[issueNumber]} repo: ${argResults?[repoName]}/${argResults?[org]}');
    var issue = Issue(
        org: argResults![org],
        repoName: argResults![repoName],
        number: argResults![issueNumber]);
    await issue.init();
    final valid = await isValidIssue(issue);
  }
}
