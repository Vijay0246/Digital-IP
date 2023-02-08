variable "client_id" {
    default = "e43a4706-475b-4371-abdc-cd0f7e20d874"
}
variable "client_secret" {
    default = "So6suh4Mt.KG2sqtiy_7.NAW2sIR24k~CH"
}

variable "agent_count" {
    default = 3
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
    default = "k8sdns"
}

variable cluster_name {
    default = "k8scluster"
}

variable resource_group_name {
    default = "azure-k8s"
}

variable location {
    default = "East US"
}

variable log_analytics_workspace_name {
    default = "myLogAnalyticsWorkspaceName"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
    default = "eastus"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable log_analytics_workspace_sku {
    default = "PerGB2018"
}