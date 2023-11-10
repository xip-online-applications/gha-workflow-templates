# aws-eks-helm-deploy
Deploy a Helm chart to an AWS EKS cluster. This workflow use the GitHub OIDC connector.

## Inputs
* `command`: The command to trigger the deployment. You can use two replacements: {0} = `environment`, {1} = `tag`;
* `environment`: The environment variable to use;
* `tag`: The tag variable to use, defaults to `latest`;
* `aws-role-arn`: The AWS role to assume;
* `aws-region`: The AWS region to assume the role in;
* `aws-session-name`: The AWS session name, defaults to `xip-gha-aws-eks-helm-deploy`;
* `aws-cluster-name`: The name of the EKS cluster to deploy to;
* `aws-kubernetes-role-arn`: The AWS role to assume in the Kubernetes cluster;
* `helm-version`: helm version to install, default is `latest`;
* `github-token`: your GitHub PAT to use for pulling the latest helm version;
* `git-crypt-key`: the [base64 git-crypt key](../git-crypt-unlock) to use if you want to decrypt the repository.

## Outputs
_none_
