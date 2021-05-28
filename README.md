[![License](https://img.shields.io/:license-mit-blue.svg)](https://badges.mit-license.org)
[![GitHub issues](https://img.shields.io/github/issues/n0npax/crystal-ball.svg)](https://GitHub.com/n0npax/crystal-ball/issues/)
![action](https://github.com/n0npax/crystal-ball/actions/workflows/dart.yaml/badge.svg)
![action](https://github.com/n0npax/crystal-ball/actions/workflows/docker.yaml/badge.svg)


# Crystal Ball

Github action to react on dummy issues report.

## Why?

More or less often we are expecting issues which are not actionable.

Empty issue body is an example of unactionable issue.
Simillarly if issue template with checklist is given but no field is selected, it's possible to consider an issue as not ready to be triaged.

The `Crystal Ball` action will check issue description and respond to it base on predefined checks or customer provided regular expressions

## Example

How action may look like:

![alt text](assets/example.png "example")

## Usage

### Action

```yaml

```

### Parameters

```yaml
name: crystall ball (from Dockerfile)
on:
  issues:
    types: [opened, edited]
jobs:
  hello_world_job:
    runs-on: ubuntu-latest
    name: Fortune teller
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Crystal Ball
        # rm line below if you want to apply same rules for PR description
        if: ${{ !github.event.issue.pull_request }}
        uses: n0npax/crystal-ball
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          CRYSTAL_NOMATCH_REGEX_FOO: '^foo$'
          CRYSTAL_MATCH_REGEX_BAR: 'bar{4}'
          # COMMENT_MSG: blah blah blah
        with:
          org: ${{ github.repository_owner }}
          repoName: crystal-ball
          issueNum: "${{ github.event.issue.number }}"
          labels: "invalid,crystall ball needed"

```

### ENV variables

Default comment message cen be changed by:
```
COMMENT_MSG: "comment message (above failure reason)
```
Multiple regular expressions can be used to validate issue body. Any ENV variable starting with `CRYSTAL_{NO,}MATCH_REGEX` will be used. If match exists, issue is consider as invalid and crystal ball will comment.
```
CRYSTAL_NOMATCH_REGEX_FOO: '^foo$'
CRYSTAL_MATCH_REGEX_BAR: 'bar{4}'
```
Github token is required to perform actions.
```
GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## LICEMSE

Code under [MIT license](https://opensource.org/licenses/MIT).
