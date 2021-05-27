import 'package:github/github.dart' as gh;
import 'package:logging/logging.dart';

final github = gh.GitHub(auth: gh.findAuthenticationFromEnvironment());
final log = Logger('issue');

class Issue extends gh.Issue {
  final String repoName, org;
  @override
  final int id;
  final slug;

  gh.Issue? _issue;

  gh.Issue get issue => _issue!;

  Issue({
    required this.org,
    required this.repoName,
    required number,
  })   : id = int.parse(number),
        slug = gh.RepositorySlug(org, repoName);

  Future<void> init() async {
    final _issService = gh.IssuesService(github);
    try {
      _issue = await _issService.get(slug, id);
    } catch (e) {
      log.shout(e);
      rethrow;
    }

    pullRequest = _issue!.pullRequest;
    body = _issue!.body;
    log.fine('Issue data was synced');
  }

  Future<void> comment(String body) async {
    final _issService = gh.IssuesService(github);
    try {
      await _issService.createComment(slug, id, body);
    } catch (e) {
      log.shout(e);
      rethrow;
    }
    log.fine('Label was added');
  }

  Future<void> addLabels(List<String> labels) async {
    final _issService = gh.IssuesService(github);
    try {
      await _issService.addLabelsToIssue(slug, id, labels);
    } catch (e) {
      log.shout(e);
      rethrow;
    }
    log.fine('Comment was added');
  }

  Future<void> rmLabels(List<String> labels) async {
    final _issService = gh.IssuesService(github);
    try {
      labels.forEach((element) {
        _issService
            .removeLabelForIssue(slug, id, element)
            .then((value) => null);
      });
    } catch (e) {
      log.shout(e);
      rethrow;
    }
    log.fine('Comment was added');
  }
}
