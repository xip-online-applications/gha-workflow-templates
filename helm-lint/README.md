# helm-lint
Lint a local helm chart in your own way.

## Inputs
* `command`: The command to use during linting. You can use two replacements: {0} = `environment`, {1} = `tag`;
* `environment`: The environment variable to use;
* `tag`: The tag variable to use;
* `helm-version`: helm version to install, default is `latest`;
* `github-token`: your GitHub PAT to use for pulling the latest helm version;
* `git-crypt-key`: the [base64 git-crypt key](../git-crypt-unlock) to use if you want to decrypt the repository.

## Outputs
_none_
