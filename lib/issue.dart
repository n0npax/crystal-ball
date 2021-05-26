import 'package:github/github.dart' as gh;

final github = gh.GitHub(auth: gh.findAuthenticationFromEnvironment());

class Issue extends gh.Issue {
  final String repoName, org;
  @override
  final int id;

  gh.Issue? _issue;

  gh.Issue get issue => _issue!;

  Issue({
    required this.org,
    required this.repoName,
    required number,
  }) : id = int.parse(number);

  Future<void> init() async {
    final _issService = gh.IssuesService(github);
    _issue = await _issService.get(gh.RepositorySlug(org, repoName), id);

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
  }
}
