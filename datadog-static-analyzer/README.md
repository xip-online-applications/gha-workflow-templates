# DataDog Static Analyzer Action

This action is a wrapper around the official [DataDog/datadog-static-analyzer-github-action](https://github.com/DataDog/datadog-static-analyzer-github-action). It runs DataDog Static Analysis on your codebase to identify code quality and security issues, and uploads the results to DataDog.

## What it does

The underlying DataDog action:

- **Analyzes Code**: Scans your source code using DataDog's Static Analyzer to detect bugs, security vulnerabilities, and code quality issues.
- **Diff-Aware Scanning**: By default, it uses diff-aware scanning to only analyze files changed in a pull request, saving time.
- **Uploads Results**: Sends the analysis report to the specified DataDog site (defaulting to `datadoghq.eu` in this wrapper).
- **Secret Detection**: Can optionally scan for hardcoded secrets (disabled by default).
- **Supports Multiple Languages**: Capable of scanning Docker, Java, JavaScript, PHP, Python, TypeScript, and more.

## Added Features in this Wrapper

This wrapper action includes an optional step to unlock `git-crypt` encrypted files before running the analysis. This is useful if your repository contains encrypted secrets or configuration files that need to be accessible during the scan.

## Inputs

| Input                           | Description                                                      | Required | Default        |
|---------------------------------|------------------------------------------------------------------|----------|----------------|
| `dd_api_key`                    | DataDog API key with permissions to create SAST reports.         | Yes      |                |
| `dd_app_key`                    | DataDog application key with permissions to create SAST reports. | Yes      |                |
| `git-crypt-key`                 | The base64 encoded git-crypt decryption key.                     | No       |                |
| `dd_site`                       | DataDog site to send the SAST report to.                         | No       | `datadoghq.eu` |
| `cpu_count`                     | Number of CPUs to use for the scan.                              | No       | `2`            |
| `enable_performance_statistics` | Enable performance statistics collection.                        | No       | `false`        |
| `subdirectory`                  | Subdirectory to run the scan in.                                 | No       | `""`           |
| `diff_aware`                    | Enable diff-aware scanning (scan only changed files in PRs).     | No       | `true`         |
| `secrets_enabled`               | Enable secrets scanning.                                         | No       | `false`        |
| `static_analysis_enabled`       | Enable static analysis scanning.                                 | No       | `true`         |

## Usage Example

```yaml
jobs:
  static-analysis:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Run DataDog Static Analyzer
        uses: xip-online-applications/gha-workflow-templates/datadog-static-analyzer@main
        with:
          dd_api_key: ${{ secrets.DD_API_KEY }}
          dd_app_key: ${{ secrets.DD_APP_KEY }}
          # Optional: Unlock git-crypt if needed
          # git-crypt-key: ${{ secrets.GIT_CRYPT_KEY }}
```

## Configuration

To customize the rulesets used by the analyzer, you can add a `static-analysis.datadog.yml` file to your repository's root directory. Refer to the [DataDog documentation](https://docs.datadoghq.com/code_analysis/static_analysis_rules/) for more details on configuration and available rulesets.
