## Installation

```bash
cd install
./install -p password1!
```

## Usage

 - **As cluster-admin, I want to add a new tenant:**
   - Create new folder <tenant_name> under `argo-apps/tenants`
   - Copy content from one of the previously created tenants (i.e. tenant1) into the new folder
   - Fill in the values.yaml appropriately - each `env` entry correspond to a namespace (i.<tenant-name>-<env>)
   - The new tenant configuration does following:
     - Adds all the required namespaces (i.e. tenant1-dev, uat, stage, gitops)
     - Creates Instance Scoped ArgoCD instance which can manage above namespaces
     - Creates ApplicationSet which allows tenants to deploy their application into namespace specific ArgoCD Applications

  - **As a tenant, I want to deploy a new application into my namespace**
    -  
  
  
