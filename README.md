# Kubernetes AzureAD integration

A complementary module to Kubernetes (AKS) module to create the server and client application required for Azure AD integration. It will output the client application id, server application id and password required as input parameters to `avinor/kubernetes/azurerm` module.

This module requires elevated access to be able to create the application in AzureAD and potensially grant access. It is therefore not recommended to be run as any CI/CD pipeline, but instead manually before running any automated process. The output can still be used by reading remote state.

It is important to grant access to the application before using them for Kubernetes deployment. See [grant access](#grant_access) for details.

Accesses are based on [Microsoft documentation](https://docs.microsoft.com/en-us/azure/aks/azure-ad-integration-cli).

## Usage

Examples use [tau](https://github.com/avinor/tau).

```terraform
module {
    source = "avinor/kubernetes-azuread-integration/azurerm"
    version = "1.0.0"
}

inputs {
    server_name = "aks-server"
    client_name = "aks-client"
    end_date = "2020-01-01T00:00:00Z"
}
```

Output from this module can then be used when deploying Kubernetes cluster.

## Grant access

If `grant_access` is set to true it will also try to grant access to the Azure AD application, however this requires admin access in Azure AD. If for security reasons this is not possible leave it as default to `false` and grant access manually after deployment.
