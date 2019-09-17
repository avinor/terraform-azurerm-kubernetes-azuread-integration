module "aks-azuread" {
    source = "../../"

    server_name = "aks-server"
    client_name = "aks-client"
    end_date = "2020-01-01T00:00:00Z"
}