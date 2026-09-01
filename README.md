# Azure Landing Zone (Terraform)

A simplified but realistic **Azure Landing Zone** built with Terraform — implementing Hub-Spoke networking, network security, centralized monitoring, and governance policy, following core Cloud Adoption Framework (CAF) principles.

## Why this project
Enterprise Azure environments are built on "landing zones" — a pre-configured, governed foundation for deploying workloads safely. This project demonstrates the core building blocks: network segmentation, security controls, monitoring, and policy enforcement, all managed as reusable Terraform modules.

## Architecture
```
                 ┌─────────────────────┐
                 │   Hub VNet (10.0.0.0/16) │
                 │   - Shared subnet        │
                 └───────────┬──────────┘
                             │ VNet Peering
                 ┌───────────┴──────────┐
                 │  Spoke VNet (10.1.0.0/16)│
                 │  - Workload subnet       │
                 │  - NSG attached           │
                 └──────────────────────┘

        + Log Analytics Workspace (centralized monitoring)
        + Azure Policy (enforces "Environment" tag on resource groups)
```

## Tech Stack
- Terraform (HCL)
- Azure Provider (azurerm)
- Modular structure (networking, governance)

## Project Structure
```
terraform-azure-landing-zone/
├── main.tf                        # Root module — ties everything together
├── variables.tf                   # Root input variables
├── outputs.tf                     # Root outputs
├── modules/
│   ├── networking/
│   │   ├── main.tf                # Hub-Spoke VNets, peering, NSG
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── governance/
│       ├── main.tf                # Log Analytics + Azure Policy
│       ├── variables.tf
│       └── outputs.tf
```

## What Gets Deployed
- **Resource Group** to contain the landing zone
- **Hub VNet** with a shared services subnet
- **Spoke VNet** with a workload subnet, peered to the Hub
- **Network Security Group** on the spoke subnet (allows HTTPS, denies all else by default)
- **Log Analytics Workspace** for centralized logging/monitoring
- **Azure Policy assignment** enforcing an `Environment` tag on the resource group

## How to Deploy
```bash
terraform init
terraform plan
terraform apply
```

To tear down:
```bash
terraform destroy
```

## Design Decisions
- **Modular structure** — networking and governance are separate modules so they can be reused independently across environments
- **NSG default-deny** — only HTTPS explicitly allowed; everything else denied by default (least-privilege principle)
- **Tagging enforced via Policy** — ensures cost tracking and ownership accountability across resources

## Possible Extensions
- Add Azure Firewall in the Hub for centralized egress control
- Add Management Group hierarchy for multi-subscription governance
- Integrate with the CI/CD pipeline project to auto-deploy on merge to `main`

## Author
Muskan Rastogi
