######## Project variables #########
variable "project_name" {
    type = string
}

variable "environment" {
    type = string
    default = "dev"
}

variable "common_tags"{
    type = map
}

###### VPC variables ###############
variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
    type = bool
    default= true
}

variable "vpc_tags" {
    type = map
    default = {}
}

######### Internet Gatway tags ##############

variable "igw_tags" {
    type = map
    default = {}
}

########## public subnet variables ##########

variable "public_subnet_cidrs" {
    type = list
    validation {
        condition = length(var.public_subnet_cidrs) == 2
        error_message = "please provide 2 vaild public subnet CIDR"
    }
}

variable "public_subnet_cidrs_tags" {
    type = map
    default = {}
}

########## private subnet variables ##########

variable "private_subnet_cidrs" {
    type = list
    validation {
        condition = length(var.private_subnet_cidrs) == 2
        error_message = "please provide 2 vaild private subnet CIDR"
    }
}

variable "private_subnet_cidrs_tags" {
    type = map
    default = {}
}

########## database subnet variables ##########

variable "database_subnet_cidrs" {
    type = list
    validation {
        condition = length(var.database_subnet_cidrs) == 2
        error_message = "please provide 2 vaild database subnet CIDR"
    }
}

variable "database_subnet_cidrs_tags" {
    type = map
    default = {}
}

variable "database_subnet_group_tags" {
    type = map
    default = {}
}

##### NAT Gateway tags ############
variable "nat_gateway_tags" {
    type = map
    default = {}
}

###### public route table tags #######
variable "public_route_table_tags" {
    type = map
    default = {}
}

###### private route table tags #######
variable "private_route_table_tags" {
    type = map
    default = {}
}


###### databse route table tags #######
variable "database_route_table_tags" {
    type = map
    default = {}
}

######## Peering ###########

variable "is_peering_required" {
    type = bool
    default = false
}

variable "acceptor_vpc_id" {
    type = string
    default = ""
}

variable "vpc_peering_tags" {
    type = map
    default = {}
}

