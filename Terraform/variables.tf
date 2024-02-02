# Defining the cidr for the VPC
variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

# Defining the cidr for the public subnet
variable "subnet_cidr" {
    default = "10.0.1.0/24"
}

# Defining the cidr for the private subnet
variable "subnet2_cidr" {
    default = "10.0.2.0/24"
}

# Creating Tags for Jenkins Instances
variable "Jenkins_tags" {
    type = list
    default = ["Jenkins Master", "Jenkins Agent 1", "Jenkins Agent 2"]
}