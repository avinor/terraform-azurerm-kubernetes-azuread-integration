output "client_app_id" {
  description = "The application id of AzureAD client application created."
  value       = azuread_application.client.application_id
}

output "server_app_id" {
  description = "The application id of AzureAD server application created."
  value       = azuread_application.server.application_id
}

output "server_app_secret" {
  description = "Password for service principal."
  value       = azuread_service_principal_password.server.value
  sensitive   = true
}