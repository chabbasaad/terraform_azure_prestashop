# Module de mise en réseau pour sécuriser l'infrastructure Taylor Shift
# Utilisé principalement en production pour isoler les ressources

resource "random_string" "network_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Virtual Network principal
resource "azurerm_virtual_network" "main" {
  count               = var.enable_vnet ? 1 : 0
  name                = "ts-vnet-${var.environment}"
  address_space       = [var.vnet_address_space]
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    Environment = var.environment
    Project     = "taylor-shift"
  }
}

# Subnet pour les Container Apps
resource "azurerm_subnet" "container_apps" {
  count                = var.enable_vnet ? 1 : 0
  name                 = "snet-container-apps"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main[0].name
  address_prefixes     = [var.container_apps_subnet_address]

  delegation {
    name = "Microsoft.App.environments"
    service_delegation {
      name = "Microsoft.App/environments"
    }
  }
}

# Subnet pour la base de données
resource "azurerm_subnet" "database" {
  count                = var.enable_vnet ? 1 : 0
  name                 = "snet-database"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main[0].name
  address_prefixes     = [var.database_subnet_address]

  delegation {
    name = "Microsoft.DBforMySQL/flexibleServers"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
    }
  }

  service_endpoints = ["Microsoft.Storage"]
}

# Network Security Group pour les Container Apps
resource "azurerm_network_security_group" "container_apps" {
  count               = var.enable_vnet ? 1 : 0
  name                = "nsg-container-apps-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Autoriser le trafic HTTP/HTTPS entrant
  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = var.environment
    Project     = "taylor-shift"
  }
}

# Association NSG avec le subnet Container Apps
resource "azurerm_subnet_network_security_group_association" "container_apps" {
  count                     = var.enable_vnet ? 1 : 0
  subnet_id                 = azurerm_subnet.container_apps[0].id
  network_security_group_id = azurerm_network_security_group.container_apps[0].id
}

# Network Security Group pour la base de données
resource "azurerm_network_security_group" "database" {
  count               = var.enable_vnet ? 1 : 0
  name                = "nsg-database-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Autoriser le trafic MySQL depuis les Container Apps
  security_rule {
    name                       = "AllowMySQL"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = var.container_apps_subnet_address
    destination_address_prefix = "*"
  }

  tags = {
    Environment = var.environment
    Project     = "taylor-shift"
  }
}

# Association NSG avec le subnet database
resource "azurerm_subnet_network_security_group_association" "database" {
  count                     = var.enable_vnet ? 1 : 0
  subnet_id                 = azurerm_subnet.database[0].id
  network_security_group_id = azurerm_network_security_group.database[0].id
}

# DNS Zone privée pour la base de données (si requis)
resource "azurerm_private_dns_zone" "database" {
  count               = var.enable_vnet && var.enable_private_dns ? 1 : 0
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = var.resource_group_name

  tags = {
    Environment = var.environment
    Project     = "taylor-shift"
  }
}

# Lien DNS Zone avec VNet
resource "azurerm_private_dns_zone_virtual_network_link" "database" {
  count                 = var.enable_vnet && var.enable_private_dns ? 1 : 0
  name                  = "ts-dns-link-${var.environment}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.database[0].name
  virtual_network_id    = azurerm_virtual_network.main[0].id

  tags = {
    Environment = var.environment
    Project     = "taylor-shift"
  }
}