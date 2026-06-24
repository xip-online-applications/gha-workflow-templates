---
name: operations-deployment-checklist
description: Runs a structured deployment checklist before applying changes to Kubernetes/Helm environments, verifying configuration, variables, and readiness.
---

# operations-deployment-checklist

Run a thorough deployment checklist before any release or configuration change reaches a cluster. Verify that all environment variables, secrets, config values, and infrastructure prerequisites are accounted for.

## When to use

Use this skill when:

- Deploying a new version of a service to any environment (staging, production)
- Updating Helm values, Kubernetes manifests, or deployment configurations
- Introducing a new environment variable, secret, or config map entry in application code
- Changing infrastructure resources (replicas, resource limits, ingress rules)
- Rolling back a deployment

## Instructions

### Step 1: Detect configuration changes

1. **Scan the diff.** Compare the current changes against the deployed state. Identify any new or modified:
   - Environment variables (in code, `.env` files, Helm values, ConfigMaps, or container specs)
   - Secrets references
   - Config map entries
   - Feature flags
   - Service endpoints or URLs
   - Resource limits (CPU, memory)
   - Volume mounts or persistent storage

2. **Cross-reference application code.** If a new `process.env.X`, `$_ENV['X']`, `os.environ['X']`, or equivalent is introduced in application code, verify it has a corresponding entry in the deployment manifests.

3. **Report findings.** List every configuration addition or change detected. For each one, state:
   - Name of the variable/secret/config
   - Where it is consumed (file and line)
   - Where it should be defined (Helm values, ConfigMap, Secret, etc.)
   - Whether a default/fallback exists in code

### Step 2: Ask the user to confirm values

For every new or changed configuration value, ask the user explicitly:

1. **"Has `<VARIABLE_NAME>` been set in the target environment?"**
   - If it is a secret: "Has the secret been created/updated in the cluster's secret store?"
   - If it has no default: "This variable has no fallback — the application will fail without it. Please confirm it is set."

2. **"Is the value correct for this environment?"** (e.g., staging URL vs. production URL)

3. **"Does this value differ between environments?"** If yes, confirm each environment has the correct value.

Do not proceed until the user confirms all configuration values are in place.

### Step 3: Verify Helm/Kubernetes readiness

1. **Helm values completeness.** Verify all required values in `values.yaml` (or environment-specific overrides) are populated. Flag any that are empty, commented out, or set to placeholder values like `TODO`, `CHANGEME`, `<replace>`.

2. **Image tag.** Confirm the container image tag matches the intended release version. Flag if it points to `latest` in production.

3. **Resource limits.** Verify CPU and memory requests/limits are set. Flag containers without resource limits.

4. **Replicas.** Confirm replica count is appropriate for the target environment. Flag single-replica deployments in production without a justification.

5. **Health checks.** Verify liveness and readiness probes are defined. Flag any container without them.

6. **Ingress/networking.** If routes changed, confirm:
   - DNS records exist or are planned
   - TLS certificates are provisioned
   - Network policies allow required traffic

7. **Persistent storage.** If volumes are added or resized, confirm the storage class exists and capacity is sufficient.

### Step 4: Verify dependencies and ordering

1. **Database migrations.** If the deployment requires schema changes:
   - "Have migrations been run (or will they run automatically on startup)?"
   - "Are migrations backward-compatible with the currently running version?" (for zero-downtime deployments)

2. **Dependent services.** If the deployment depends on another service being updated first:
   - "Has `<dependency>` already been deployed with the required changes?"
   - "Is the API contract between services compatible?"

3. **Feature flags.** If new functionality is behind a flag:
   - "Is the flag configured in the target environment?"
   - "Should it be enabled or disabled at deploy time?"

### Step 5: Verify rollback readiness

1. **"Can this deployment be rolled back safely?"** Check for:
   - Irreversible migrations
   - Breaking contract changes with upstream/downstream services
   - One-way data transformations

2. **"Is the previous image/version still available?"** Verify the prior version tag exists in the registry.

3. **"Is there a runbook or known procedure for rollback?"** If not, flag it as a risk.

### Step 6: Final checklist confirmation

Present a summary checklist and require explicit user sign-off:

```markdown
## Deployment Checklist — <service> → <environment>

### Configuration
- [ ] All new environment variables are set in the target environment
- [ ] All secrets are created/updated in the secret store
- [ ] Values are correct for this specific environment (not copied from another)

### Kubernetes/Helm
- [ ] Image tag points to the correct release version
- [ ] Resource requests and limits are defined
- [ ] Health checks (liveness + readiness) are configured
- [ ] Replica count is appropriate for the environment
- [ ] Ingress/DNS/TLS are configured (if applicable)

### Dependencies
- [ ] Database migrations are applied or will auto-run
- [ ] Dependent services are deployed and compatible
- [ ] Feature flags are configured

### Rollback
- [ ] Deployment can be rolled back without data loss
- [ ] Previous version is available in the registry

### Sign-off
- [ ] Engineer confirms: ready to deploy
```

Do not proceed with deployment until every applicable item is checked or explicitly marked as not applicable with a reason.

### Step 7: Post-deployment verification

After the deployment is applied:

1. **Monitor pod status.** Verify all pods reach `Running` state and pass readiness checks.
2. **Check logs.** Look for error-level log entries in the first 2–5 minutes.
3. **Smoke test.** If a health endpoint or basic functionality check exists, run it.
4. **Alert the user** if anything looks abnormal, even if pods are technically running.

## Principles

- **Never assume configuration is correct.** Always verify explicitly.
- **Err on the side of blocking.** A delayed deployment is better than a broken one.
- **Make the invisible visible.** Surface every implicit dependency and assumption.
- **One environment at a time.** Never deploy to multiple environments simultaneously without explicit confirmation.
