variable "az_resourcegroup" {
  description	= "리소스그룹 이름 지정"
  type		= string
  default	= "sychang"
}

variable "az_location" {
  description	= "리소스그룹 location 지정"
  type		= string
  default	= "Korea Central"
}

variable "rhaap_eda_username" {
  description	= "eda username"
  type		= string
  default	= "admin"
}

variable "rhaap_eda_password" {
  description	= "eda password"
  type		= string
  default	= "Rplinux12#$"
}

variable "rhaap_eda_url" {
  description	= "EDA URL"
  type		= string
  default	= "https://ansible.rockplace.com:443/eda-event-streams/api/eda/v1/external_event_stream/f5fa6d07-172f-4d90-878d-76e9334232fb/post/"
}

variable "azure_client_secret" {
  description	= "azure client secret"
  type		= string
  default	= "Noe8Q~ENBjVROUIw-MxdEi1d-pM.fNPqhiqc3c4T"
}

variable "aap_password" {
  description	= "rhaap admin password"
  type		= string
  default	= "Rplinux12#$"
}
