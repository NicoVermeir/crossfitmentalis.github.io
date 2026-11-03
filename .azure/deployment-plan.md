# Azure Deployment Plan

Status: Validated

Generated: 2026-10-04

## Application

- Project: CrossFit Mentalis static website
- Workspace: `D:\Projects\Mentalis`
- Deployment mode: New Azure App Service deployment
- Target hostname: `crossfitmentalis.azurewebsites.net`

## Azure Context

- Subscription: `ME-MngEnvMCAP376651-nicovermeir-3`
- Subscription ID: `d885d9f5-e975-4ecc-8a3d-6fda18883f6b`
- Resource group: `rg-CrossfitEnv`
- Region: `swedencentral`

## Requirements

| Attribute | Value |
|---|---|
| Classification | Production, small public website |
| Scale | Small (<1K expected concurrent users) |
| Budget | Cost-optimized |
| Subscription | `ME-MngEnvMCAP376651-nicovermeir-3` |
| Location | Sweden Central |

## Components Detected

| Component | Type | Technology | Path |
|---|---|---|---|
| CrossFit Mentalis website | Frontend | Static HTML, CSS, JavaScript, local PNG/JPG assets | Workspace root |

## Policy Constraints

- Subscription and management-group policy assignments were queried.
- `MCAPSGov Deny Policies` and `Block Azure RM Resource Creation` are assigned at management-group scope; deployment must be tested with a preview/what-if and may require the subscription's approved deployment path.
- No required App Service tags or region restrictions were returned by the policy query.

## Architecture

- Hosting: Azure App Service for Linux
- Workload: Static HTML, CSS, JavaScript, and local image assets
- Runtime/startup: Node.js 20 LTS with a dependency-free `server.js` static file server
- SKU: B1 Basic Linux App Service Plan
- TLS: HTTPS-only

## Deployment Recipe

- Recipe: Bicep via Azure CLI
- Infrastructure as code: `infra/main.bicep`
- Deployment method: Azure CLI resource-group deployment plus ZIP deployment

## Resource Inventory and Capacity

| Resource Type | Number to Deploy | Current Usage | Limit/Quota | Total After Deployment | Notes |
|---|---:|---:|---|---:|---|
| Microsoft.Web/serverfarms | 1 | 0 | No limit reported | 1 | B1 Linux plan |
| Microsoft.Web/sites | 1 | 0 | No limit reported | 1 | `crossfitmentalis` |

Quota and region checks completed for `swedencentral`; App Service resource types are available and the quota service reported no limit.

## Plan Approval

Approved by user on 2026-10-04.

## Scope and Security

- Create only the resources required to host the website.
- Do not modify or delete existing resources.
- Keep all site assets local to the deployment package.
- Enable HTTPS-only access.

## Validation Steps

- [x] Bicep compilation: `az bicep build --file .\infra\main.bicep`
- [x] Bicep lint: `az bicep lint --file .\infra\main.bicep`
- [x] Resource-group template validation: `az deployment group validate --resource-group rg-CrossfitEnv --subscription d885d9f5-e975-4ecc-8a3d-6fda18883f6b --template-file .\infra\main.bicep --parameters .\infra\main.parameters.json`
- [x] Resource-group what-if preview: `az deployment group what-if --resource-group rg-CrossfitEnv --subscription d885d9f5-e975-4ecc-8a3d-6fda18883f6b --template-file .\infra\main.bicep --parameters .\infra\main.parameters.json`
- [x] Azure authentication: `az account show --subscription d885d9f5-e975-4ecc-8a3d-6fda18883f6b`
- [x] Policy assignment review through Azure Policy MCP at the target resource-group scope.

## Role Assignment Verification

- Status: Verified
- Identities checked: None; the static site does not require a managed identity or Azure data-plane access.
- Roles confirmed: None required.
- Issues: Removed the unused system-assigned identity from `infra/main.bicep` to keep the deployment least-privilege.

## Validation Proof

- `validate-deployment.ps1 -Scope group -ResourceGroup rg-CrossfitEnv` completed with `OVERALL: PASS` on 2026-10-06 before republishing the latest app files; Azure authentication, Bicep compilation, resource-group validation, and what-if preview all passed.
- `node --check .\server.js` and `node --check .\script.js` passed; `styles.css` contains balanced braces and was included in the deployment package.
- `validate-deployment.ps1 -Scope group -ResourceGroup rg-CrossfitEnv` completed with `OVERALL: PASS` on 2026-10-06 before publishing the walk-in information panel; Azure authentication, Bicep compilation, resource-group validation, and what-if preview all passed.
- `node --check .\server.js` and `node --check .\script.js` passed; the page contains one `walk-in` panel, five `mailto:info@crossfitmentalis.com` links, and all three `walkInTitle` translation keys.
- `validate-deployment.ps1 -Scope group -ResourceGroup rg-CrossfitEnv` completed with `OVERALL: PASS` on 2026-10-06 after the contact and Level 3 coach copy updates.
- `node --check .\server.js` and `node --check .\script.js` passed; the HTML contains four `mailto:info@crossfitmentalis.com` links, no Linktree references, and the updated Level 3 coach copy.
- `validate-deployment.ps1 -Scope group -ResourceGroup rg-CrossfitEnv` completed with `OVERALL: PASS` on 2026-10-06; Azure CLI authentication, Bicep compilation, resource-group validation, and what-if preview all passed.
- `node --check .\server.js` and `node --check .\script.js` completed successfully on 2026-10-06.
- Required deployment files, including `assets\mentalis-wordmark.svg`, were present on 2026-10-06.
- `az account show` succeeded for subscription `ME-MngEnvMCAP376651-nicovermeir-3` (`d885d9f5-e975-4ecc-8a3d-6fda18883f6b`).
- `az bicep build` completed successfully with no compilation errors.
- `az bicep lint` completed successfully with no lint errors.
- `az deployment group validate` returned `provisioningState: Succeeded` and `error: null`.
- `az deployment group what-if` returned `error: null` and exactly two planned creates: the Linux App Service Plan `crossfitmentalis-plan` and Web App `crossfitmentalis`; no deletes or modifies.
- Azure Policy MCP returned the applicable management-group and subscription policy assignments for the target scope. No additional template changes were required after the preview.
- Local verification: `node --check .\server.js` succeeded; `curl.exe -I http://localhost:8080/` and `curl.exe -I http://localhost:8080/styles.css` returned HTTP 200.
- Wordmark verification: the generated SVG parsed as XML, contained 21 vector paths, and contained no embedded raster image.

## Execution Log

- User approved the plan on 2026-10-04.
- Generated `server.js`, `package.json`, `infra/main.bicep`, and `azure.yaml`.
- Added `infra/main.parameters.json`.
- Removed the unused system-assigned identity from the App Service definition.
- Validation completed successfully.
- Redeployed the smoothed wordmark SVG and verified the live site, SVG asset, and HTTPS redirect on 2026-10-05.
