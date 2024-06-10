## Installation

```bash
cd install
./install -p password1!
```

## Usage

 - **As cluster-admin, I want to add a new tenant:**
   - Create new folder <tenant_name> under `argo-apps/tenants`
   - Copy content from one of the previously created tenants (i.e. tenant1) into the new folder
   - Fill in the values.yaml appropriately - each `env` entry correspond to a namespace (i.e. `<tenant-name>-<env>` )
   - The new tenant configuration does following:
     - Adds all the required namespaces (i.e. tenant1-dev, uat, stage, gitops)
     - Creates namespace-scoped ArgoCD instance - into `<tenant-name>-gitops` namespace which can manage  all the namespaces above
     - Creates ApplicationSet - in `<tenant-name>-gitops` -  which allows tenants to deploy their application into namespace specific ArgoCD Applications

 - **As a tenant, I want to deploy a new application into my namespace**
    -  each entry in the `env` (i.e. dev, stage, uat) corresponds to specific environment ( == namespace)
    -  Simply create a new directory under `argoa-apps/tenants/<tenant-name>` - name of the directory must equal to one of the `env` entry - and start placing OpenShift manifests (or helm chart, kustomize) into this folder
    -  No need to take care of specifics of ArgoCD - everything is taken care of, you only manipulate with OCP manifests and nothing else
  
  
