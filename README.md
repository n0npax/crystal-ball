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

```

### ENV variables

Default comment message cen be changed by:
```
COMMENT_MSG: "comment message (above failure reason)
```
Multiple regular expressions can be used to validate issue body. Any ENV variable starting with `REGEX` will be used. If match exists, issue is consider as invalid and crystal ball will comment.
```
REGEX_FOO: '^foo$'
REGEX_BAR: 'bar{4}'
```
Github token is required to perform actions.
```
GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## LICEMSE

Code under [MIT license](https://opensource.org/licenses/MIT).
