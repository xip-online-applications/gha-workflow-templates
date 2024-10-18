# xip-online-applications/gha-workflow-templates/ghcr-build-push

Build a container and push it the GitHub container registry (ghcr.io).

## Inputs

* `aws-role-arn`: The AWS role to assume;
* `aws-region`: The AWS region to assume the role in;
* `aws-session-name`: The AWS session name, defaults to `xip-gha-aws-ecr-build-push`;
* `repository`: The ECR repository name to push to;
* `tag`: The tag to apply to the image;
* `context`: The container build context, defaults to `.`;
* `dockerfile`: The Dockerfile to build, defaults to `Dockerfile`;
* `build-args`: Build arguments you want to add to the build, use one per line like "ARG=value";
* `target`: The target build stage to build;
* `platforms`: The [platforms](https://github.com/containers/buildah/blob/main/docs/buildah-build.1.md#options) to build for, defaults to `linux/amd64`.

## Outputs

* `registry`: The ECR registry URL.
