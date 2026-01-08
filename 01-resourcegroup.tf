# 리소스 그룹 생성
resource "azurerm_resource_group" "rg" {
  name     = var.az_resourcegroup
  location = var.az_location
}
