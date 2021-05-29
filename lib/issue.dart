import 'package:github/github.dart' as gh;
import 'package:logging/logging.dart';

final github = gh.GitHub(auth: gh.findAuthenticationFromEnvironment());
final log = Logger('issue');

class Issue extends gh.Issue {
  /// GitHub Repository name
  final String repoName;

  /// GitHub Org name
  final String org;

  /// GitHub issue comments count
  int commentsCnt;

  /// Github Issue ID
  @override
  final int id;

  final _slug;

  gh.Issue? _issue;

  gh.Issue get issue => _issue!;

  Issue({
    required this.org,
    required this.repoName,
    required number,
  })  : id = int.parse(number),
        commentsCnt = -1,
        _slug = gh.RepositorySlug(org, repoName);

  /// Initialize instance by fetching data from GitHub
  Future<void> init() async {
    final _issService = gh.IssuesService(github);
    try {
      _issue = await _issService.get(_slug, id);
    } catch (e) {
      log.shout(e);
      rethrow;
    }

    commentsCnt = _issue!.commentsCount;
    pullRequest = _issue!.pullRequest;
    body = _issue!.body;
    log.fine('Issue data was synced');
  }

  /// Adds comment to the GitHub issue
  Future<void> comment(String body) async {
    final _issService = gh.IssuesService(github);
    try {
      await _issService.createComment(_slug, id, body);
    } catch (e) {
      log.shout(e);
      rethrow;
    }
    log.fine('Label was added');
  }

  /// Adds labels to the GitHub issue
  Future<void> addLabels(List<String> labels) async {
    final _issService = gh.IssuesService(github);
    try {
      await _issService.addLabelsToIssue(_slug, id, labels);
    } catch (e) {
      log.shout(e);
      rethrow;
    }
    log.info('Applied labels: $labels');
  }

  /// Removes labels to the GitHub issue
  Future<void> rmLabels(List<String> labels) async {
    final _issService = gh.IssuesService(github);
    try {
      labels.forEach((element) {
        _issService
            .removeLabelForIssue(_slug, id, element)
            .then((value) => null);
      });
    } catch (e) {
      log.shout(e);
      rethrow;
    }
    log.info('Removed labels: $labels');
  }
}
