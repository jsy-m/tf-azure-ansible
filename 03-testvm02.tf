# 생성할 vm 이름 
variable "az_vm_name_02" {
  description   = "신규 생성할 vm 이름"
  type          = string
  default	= "testvm02"
}

# 퍼블릭 IP
resource "azurerm_public_ip" "testvm02_pip" {
  name                = "${var.az_vm_name_02}-pubip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku 		      = "Standard"
}

# 네트워크 인터페이스 
resource "azurerm_network_interface" "testvm02_nic" {
  name                = "${var.az_vm_name_02}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.testvm02_pip.id
  }
}

# NIC에 NSG 연결 (혹은 Subnet에 연결)
resource "azurerm_network_interface_security_group_association" "testvm02_nic_nsg" {
  network_interface_id      = azurerm_network_interface.testvm02_nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# 가상머신
resource "azurerm_linux_virtual_machine" "testvm02_vm" {
  name                = "${var.az_vm_name_02}-test-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2ts_v2"
  admin_username      = "azureuser"
  admin_password      = "Rplinux098&^%"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.testvm02_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  tags = {
    provisioner	= "terraform"
  }

  lifecycle {
    action_trigger {
      events	= [after_create]
      actions	= [action.aap_eda_eventstream_post.testvm02_call_eda]
    }
  }
}

# EDA 트리거 발동을 위한 action 
action "aap_eda_eventstream_post" "testvm02_call_eda" {
  config {
    limit		= "terraform_aap"
    template_type	= "workflow_job"
    organization_name 	= "Default"
    workflow_job_template_name = "WT-0003_terraform-handle"

    event_stream_config	= {
      username	= var.rhaap_eda_username
      password	= var.rhaap_eda_password
      url	= var.rhaap_eda_url
      insecure_skip_verify = true
    }
  }
}
