# xip-online-applications/gha-workflow-templates/aws-serverless-deploy
Deploy a serverless application to AWS. This workflow use the GitHub OIDC connector.

# Inputs
* `stage`: The stage to deploy to;
* `aws-role-arn`: The AWS role to assume;
* `aws-region`: The AWS region to assume the role in;
* `aws-session-name`: The AWS session name, defaults to `xip-gha-aws-serverless-deploy`;
* `chroot`: The chroot to use for the deployment;
* `package-install-command`: Command to install npm packages, default to `npm ci`;
* `deploy-command`: The command to run to do the deployment. You can use one replacement: {0} = stage, {1} = `npm run serverless -- `;
* `post-deploy-command`: The commands to run after the deployment. One command per line. You can use one replacement: {0} = stage, {1} = `npm run serverless -- `;
* `node-version`: The node version to setup, defaults to `lts/*`.

## Outputs
_none_
