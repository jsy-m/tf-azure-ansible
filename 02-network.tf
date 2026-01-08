# 가상 네트워크 생성
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.az_resourcegroup}-vnet"
  address_space       = ["172.16.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# 서브넷 생성
resource "azurerm_subnet" "subnet" {
  name                 = "${var.az_resourcegroup}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["172.16.100.0/24"]
}

# NSG: SSH + ICMP 인바운드 허용
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.az_resourcegroup}-nsg-ssh-icmp-allow"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # 1) SSH 허용
  security_rule {
    name                       = "allow-ssh-in"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"          # 필요 시 특정 소스 IP로 제한 권장
    destination_address_prefix = "*"
  }

  # 2) ICMP 허용 (ping)
  security_rule {
    name                       = "allow-icmp-in"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"       # 중요: Icmp 명시
    source_port_range          = "*"          # ICMP는 포트 개념이 없으므로 '*'
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
