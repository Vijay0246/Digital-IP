data "azurerm_resource_group" "rgar" {
  name                = var.rg_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.rg_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.rgar.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

data "azurerm_storage_account" "stracc"{
    name               = var.sa_name
    resource_group_name =   data.azurerm_resource_group.rgar.name
}


resource "azurerm_public_ip" "public_ip_vm" {
  name                = var.vm_pip
  location            = data.azurerm_resource_group.rgar.location
  resource_group_name = data.azurerm_resource_group.rgar.name
  allocation_method   = "Dynamic"
}


resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rgar.name

  ip_configuration {
    name                          = var.ip_config_name
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip_vm.id
  }
}

data "azurerm_network_security_group" "nsg" {
    name                = var.nsg_name
    resource_group_name = data.azurerm_resource_group.rgar.name
}

resource "azurerm_subnet_network_security_group_association" "nicsec" {
  subnet_id                 = data.azurerm_subnet.subnet.id
  network_security_group_id = data.azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_rule" "nsgrule" {
  name                        = "mynsgrule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = data.azurerm_network_security_group.nsg.name
}

resource "azurerm_virtual_machine" "vm" {
  name                  = var.vm_name
  resource_group_name   = data.azurerm_resource_group.rgar.name
  location              = var.location
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true
  
  #disable_password_authentication = false
  
    storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8.1"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "LinuxAdmin"
    admin_password = "Password1234!"
    
  }
  os_profile_linux_config {
    disable_password_authentication = false
    }
}
  