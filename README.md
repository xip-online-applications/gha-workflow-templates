# GitHub Actions workflow templates

Welcome! This repository contains a collection of GitHub Actions workflows that can be used by anyone in their
repositories.

## Workflows

We have made a GitHub Actions workflows available that we use a lot throughout our repositories. You can find the
following workflows:

* [git-crypt-unlock](./git-crypt-unlock): Unlock a repository that is encrypted with [git-crypt](https://github.com/AGWA/git-crypt);
* [helm-lint](./helm-lint): Lint a [Helm](https://helm.sh/) chart;
* [aws-ecr-build-push](./aws-ecr-build-push): Build and push a Docker image to [AWS ECR](https://aws.amazon.com/ecr/);
* [aws-eks-helm-deploy](./aws-eks-helm-deploy): Deploy a local Helm chart to [AWS EKS](https://aws.amazon.com/eks/).
* [aws-serverless-deploy](./aws-eks-helm-deploy): Deploy a local Helm chart to [AWS EKS](https://aws.amazon.com/eks/).
* [ghcr-build-push](./ghcr-build-push): Build a container and push it the GitHub container registry (ghcr.io).

## Usage

See inside each workflow directory for more information on how to use the workflow. Each workflow has a `README.md`.
You can use each workflow with `uses: xip-online-applications/gha-workflow-templates/{WORKFLOW}@{VERSION or main}`.
See the following example:

```yaml
name: "Test git-crypt-unlock"
on:
  push:
jobs:
  job:
    name: Test git-crypt-unlock
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Git-crypt unlock
        uses: xip-online-applications/gha-workflow-templates/git-crypt-unlock@main
        with:
          git-crypt-key: "xxx"
```
