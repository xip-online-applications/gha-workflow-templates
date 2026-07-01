# GuardDog

Run GuardDog security scans on your package source and dependencies.

## Inputs

- `dir` (required: no, default: `.`): Directory to scan (contains package manifest files).
- `file` (required: no, default: `./`): Specific file or path to scan (used by `scan` mode).
- `verify` (required: no, default: empty): Optional dependency file path for `verify` mode; when set, `verify` is used instead.
- `git-crypt-key` (required: no, default: empty): Base64 encoded git-crypt key for decrypting the repository before scanning.
- `package-manager` (required: no, default: `npm`): GuardDog ecosystem: `extension`, `github_action`, `go`, `npm`, `pypi`.
- `exclude-rules` (required: no, default: empty): Comma or newline separated GuardDog rule IDs to suppress.
- `log-level` (required: no, default: empty): GuardDog log level: `debug`, `info`, `warning`, `error`, `critical`.
- `fail-on-issues` (required: no, default: `true`): Fail the job when GuardDog reports findings.
- `fail-score-threshold` (required: no, default: `7.6`): Fail only when GuardDog assessment score is greater than or equal to this value.

## Examples

### Basic usage

```yaml
- name: GuardDog
  uses: xip-online-applications/gha-workflow-templates/guarddog@main
  with:
    dir: applications/webapp
```

### Ignore known false positives

```yaml
- name: GuardDog
  uses: xip-online-applications/gha-workflow-templates/guarddog@main
  with:
    dir: applications/webapp
    package-manager: npm
    exclude-rules: |
      threat-filesystem-read
      threat-runtime-obfuscation-general
```

### Do not fail CI yet (adoption mode)

```yaml
- name: GuardDog
  uses: xip-online-applications/gha-workflow-templates/guarddog@main
  with:
    dir: applications/webapp
    fail-on-issues: "false"
```

### Use GuardDog verify on a dependency file

```yaml
- name: GuardDog
  uses: xip-online-applications/gha-workflow-templates/guarddog@main
  with:
    package-manager: npm
    verify: libs/nx-sdk/package-lock.json
```

### Fail only for high-risk assessments

```yaml
- name: GuardDog
  uses: xip-online-applications/gha-workflow-templates/guarddog@main
  with:
    dir: applications/webapp
    fail-score-threshold: "7.6"
```
