# GuardDog

Run GuardDog security scans on your package source and dependencies.

## Inputs

| Name                   | Required | Default | Description                                                                      |
| ---------------------- | -------- | ------- | -------------------------------------------------------------------------------- |
| `dir`                  | No       | `.`     | Directory to scan (contains package manifest files).                             |
| `git-crypt-key`        | No       | ``      | Base64 encoded git-crypt key for decrypting the repository before scanning.      |
| `package-manager`      | No       | `npm`   | GuardDog ecosystem: `extension`, `github_action`, `go`, `npm`, `pypi`.           |
| `exclude-rules`        | No       | ``      | Comma or newline separated GuardDog rule IDs to suppress.                        |
| `log-level`            | No       | ``      | GuardDog log level: `debug`, `info`, `warning`, `error`, `critical`.             |
| `fail-on-issues`       | No       | `true`  | Fail the job when GuardDog reports findings.                                     |
| `fail-score-threshold` | No       | `7.6`   | Fail only when GuardDog assessment score is greater than or equal to this value. |

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

### Fail only for high-risk assessments

```yaml
- name: GuardDog
  uses: xip-online-applications/gha-workflow-templates/guarddog@main
  with:
    dir: applications/webapp
    fail-score-threshold: "7.6"
```
