# GitHub Actions workflow templates

Welcome! This repository contains a collection of GitHub Actions workflows that can be used by anyone in their
repositories.

## Workflows

We have made a GitHub Actions workflows available that we use a lot throughout our repositories. You can find the
following workflows:

* [aws-ecr-build-push](./aws-ecr-build-push): Build and push a Docker image to [AWS ECR](https://aws.amazon.com/ecr/);
* [aws-eks-helm-deploy](./aws-eks-helm-deploy): Deploy a local Helm chart to [AWS EKS](https://aws.amazon.com/eks/).
* [aws-eks-vpc-update](./aws-eks-vpc-update): Update EKS VPC endpoint access with the current runner IP.
* [aws-serverless-deploy](./aws-serverless-deploy): Deploy serverless resources to AWS.
* [datadog-static-analyzer](./datadog-static-analyzer): Run DataDog Static Analyzer security scans.
* [ghcr-build-push](./ghcr-build-push): Build a container and push it the GitHub container registry (ghcr.io).
* [ghcr-login](./ghcr-login): Login to the GitHub container registry (ghcr.io).
* [git-crypt-unlock](./git-crypt-unlock): Unlock a repository that is encrypted with [git-crypt](https://github.com/AGWA/git-crypt);
* [guarddog](./guarddog): Scan packages for supply-chain security issues with GuardDog.
* [helm-lint](./helm-lint): Lint a [Helm](https://helm.sh/) chart;
* [local-docker-build](./local-docker-build): Build a Docker image locally with GitHub Actions cache support.
* [nx-s3-deploy](./nx-s3-deploy): Builds your Agular app, then deploys to S3.

## Usage

See inside each workflow directory for more information on how to use the workflow. Each workflow has a `README.md`.
You can use each workflow with `uses: xip-online-applications/gha-workflow-templates/{WORKFLOW}@{VERSION or main}`.
See the following example:

```yaml
name: 'Test git-crypt-unlock'
on:
    push:
jobs:
    job:
        name: Test git-crypt-unlock
        runs-on: ubuntu-latest
        steps:
            - name: Checkout repository
              uses: actions/checkout@v6

            - name: Git-crypt unlock
              uses: xip-online-applications/gha-workflow-templates/git-crypt-unlock@main
              with:
                git-crypt-key: 'MDExOC05OTktODgxOTktOTExOS03MjUtMwo='
```
