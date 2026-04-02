# Custome AWS VPC module
![alt text](images/vpc.jpg)

This module is developed for practice (joindevops.com), we are creating following resources. This module creates resources in first two availabilty Zones for High availability

* VPC 
* Internet Gateway
* VPC attachment
* 2 Public Subnets
* 2 Private Subents
* 2 Database Subnets
* Elastic IP 
* NAT Gateway
* Public Route table
* Private Route table
* Database Route table
* Route table and subnet associations
* Routes in all tables
* Peering if required for user
* Routes for Perring in requestor and acceptor VPC
* Databse subnet Group

### Inputs
* Project_name (Required): User should mention their project name. Type is string.
* environment (Optional): Default value is dev. Type is string.
* common_tags (Required): User should provide their tags related to their project. Type is map
* vpc_cidr (Optional): Default value is 10.0.0.0/16. Type is string
* enable_dns_hostnames (Optional): Default value is true. Type is bool
* vpc_tags (Optional): Default value is empty. Type is map
* igw_tags (Optional): Default value is empty. Type is map
* public_subnet_cidrs (Required): User has to provide 2 valid subnet CIDR
* public_subnet_cidrs_tags (Optional): Defalut value is empty. Type is map.
* private_subnet_cidrs (Required): User has to provide 2 valid subnet CIDR
* private_subnet_cidrs_tags (Optional): Defalut value is empty. Type is map.
* database_subnet_cidrs (Required): User has to provide 2 valid subnet CIDR
* database_subnet_cidrs_tags (Optional): Defalut value is empty. Type is map.
* database_subnet_group_tags (Optional): Defalut value is empty. Type is map.
* nat_gateway_tags (Optional): Default value is empty. Type is map.
* public route table tags (Optional): Default value is empty. Type is map.
* private route table tags (Optional): Default value is empty. Type is map.
* database route table tags (Optional): Default value is empty. Type is map.
* is_peering_required (Optional): Default value is false. Type is bool.
* acceptor_vpc_id (Optional): Default value is empty. default VPC ID would be taken. Type is string
* vpc_peering_tags (Optional): Default value is empty. Type is map.

### Outputs 
* vpc_id: VPC ID
* public_subnet_ids: A list of 2 public subnet IDS created.
* private_subnet_ids: A list of 2 private subnet IDS created.
* database_subnet_ids: A list of 2 database subnet IDS created.
* database_subnet_group_id: A database subnet group ID created.
* igw_id: Internet gateway created.