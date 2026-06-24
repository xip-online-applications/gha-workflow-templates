---
name: nodejs-version-setup
description: Ensures Node.js commands run with the project-required Node version before install, build, test, or scripts.
---

# nodejs-version-setup

Set and verify the correct Node.js runtime for this repository before running any Node.js command.

## When to use

Use this skill whenever the task runs Node.js tooling, including `npm`, `pnpm`, `yarn`, `npx`, build scripts, tests, linters, or local CLIs.

## Instructions

1. Detect the required Node.js version in this order:
   - `.nvmrc`
   - `.node-version`
   - `package.json` -> `engines.node`
2. Detect an installed version manager in this order:
   - `nvm`
   - `fnm`
   - `asdf`
   - `volta`
3. Select the required version with the first available manager:
   - `nvm`: `nvm install` and `nvm use`
   - `fnm`: `fnm install` and `fnm use`
   - `asdf`: `asdf install nodejs <version>` and `asdf local nodejs <version>`
   - `volta`: `volta install node@<version>`
4. If no version file exists but `engines.node` exists, resolve a concrete version inside that range and install/use it with the detected manager.
5. If no manager is available, check whether the current `node -v` satisfies the required version. If it does not, stop and ask the user to confirm whether to install a version manager or proceed manually.
6. Verify runtime before executing project commands:
   - `node -v`
   - `npm -v` (or `pnpm -v` / `yarn -v` depending on the project)
   - `which node` to confirm the active binary path
7. In task output, report which source defined the version (for example `.nvmrc`), which manager was used, and the final `node -v`.
8. Do not run dependency install, build, test, or CLI scripts until version selection and verification are complete.
