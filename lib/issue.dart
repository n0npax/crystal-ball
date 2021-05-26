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

    url = _issue!.url;
    htmlUrl = _issue!.htmlUrl;
    number = _issue!.number;
    state = _issue!.state;
    title = _issue!.title;
    user = _issue!.user;
    labels = _issue!.labels;
    assignee = _issue!.assignee;
    milestone = _issue!.milestone;
    commentsCount = _issue!.commentsCount;
    pullRequest = _issue!.pullRequest;
    createdAt = _issue!.createdAt;
    closedAt = _issue!.closedAt;
    updatedAt = _issue!.updatedAt;
    body = _issue!.body;
    closedBy = _issue!.closedBy;
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
    log.fine('Comment was added');
  }
}
