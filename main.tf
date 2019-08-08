terraform {
  required_version = ">= 0.12.0"
}

#
# Server application
#

resource "azuread_application" "server" {
  name                       = var.server_name
  identifier_uris            = ["https://${var.server_name}"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = false
  group_membership_claims = "All"

  required_resource_access {
    # MicrosoftGraph API
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    # APPLICATION PERMISSIONS: "Read directory data":
    # 7ab1d382-f21e-4acd-a863-ba3e13f7da61
    resource_access {
      id   = "7ab1d382-f21e-4acd-a863-ba3e13f7da61"
      type = "Role"
    }

    # DELEGATED PERMISSIONS: "Sign in and read user profile":
    # e1fe6dd8-ba31-4d61-89e7-88639da4683d
    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }

    # DELEGATED PERMISSIONS: "Read directory data":
    # 06da0dbc-49e2-44d2-8312-53f166ab848a
    resource_access {
      id   = "06da0dbc-49e2-44d2-8312-53f166ab848a"
      type = "Scope"
    }
  }
}

resource "azuread_service_principal" "server" {
  application_id = azuread_application.server.application_id

  tags = ["aks", "terraform", var.server_name]
}

resource "random_string" "server" {
  length  = 32
  special = false
  upper   = true

  keepers = {
    service_principal = azuread_service_principal.server.id
  }
}

resource "azuread_service_principal_password" "server" {
  service_principal_id = azuread_service_principal.server.id
  value                = random_string.server.result
  end_date             = var.end_date
}

#
# Client application
#

resource "azuread_application" "client" {
  name       = var.client_name
  reply_urls = ["https://${var.client_name}"]
  type       = "native"

  required_resource_access {
    # AKS ad application server
    resource_app_id = azuread_application.server.application_id

    resource_access {
      # Server app Oauth2 permissions id
      id   = lookup(azuread_application.server.oauth2_permissions[0], "id")
      type = "Scope"
    }
  }
}

resource "azuread_service_principal" "client" {
  application_id = azuread_application.client.application_id

  tags = ["aks", "terraform", var.client_name]
}