variable "server_name" {
  description = "Name of the server application to create."
}

variable "client_name" {
  description = "Name of the client application to create."
}

variable "end_date" {
  description = "The End Date which the Password is valid until, formatted as a RFC3339 date string (e.g. 2018-01-01T01:02:03Z)."
  default     = null
}
