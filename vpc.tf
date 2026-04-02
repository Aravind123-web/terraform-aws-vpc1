############ Creating VPC #####################
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = var.enable_dns_hostnames
  
  tags = merge (
    var.common_tags,
    var.vpc_tags,
    {
      Name = local.resource_name
    }
  )
}

############## Creating Internet Gateway ##############

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id 

  tags = merge (
    var.common_tags,
    var.igw_tags,
    {
      Name = local.resource_name
    }
  )
}

########## Creating Subnets (public/private/databse) so we should force to create two public/private/databse subnets ############################

###### public subnets ######

resource "aws_subnet" "public" {  # firstname is public[0], second name is public[1]
  count = length(var.public_subnet_cidrs)
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  tags =  merge (
    var.common_tags,
    var.public_subnet_cidrs_tags,
    {
      Name = "${local.resource_name}-public-${local.az_names[count.index]}"
    }
  )
}

###### private subnets ######

resource "aws_subnet" "private" {  # firstname is private[0], second name is private[1]
  count = length(var.private_subnet_cidrs)
  availability_zone = local.az_names[count.index] 
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  tags =  merge (
    var.common_tags,
    var.private_subnet_cidrs_tags,
    {
      Name = "${local.resource_name}-private-${local.az_names[count.index]}"
    }
  )
}

###### databse subnets ######

resource "aws_subnet" "database" { # firstname is database[0], second name is database[1]
  count = length(var.database_subnet_cidrs)
  availability_zone = local.az_names[count.index]
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]
  tags =  merge (
    var.common_tags,
    var.database_subnet_cidrs_tags,
    {
      Name = "${local.resource_name}-database-${local.az_names[count.index]}" # interpolation
    }
  )
}

###### Database subnet group #########
resource "aws_db_subnet_group" "default" {
  name       = "${local.resource_name}"
  subnet_ids = aws_subnet.database[*].id

  tags =  merge (
    var.common_tags,
    var.database_subnet_group_tags,
    {
      Name = "${local.resource_name}"
    }
  )
}

######### Creating elastic IP address ##########

resource "aws_eip" "nat" {
  domain   = "vpc"
}

######## Creating NAT Gateway ############

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge (
    var.common_tags,
    var.nat_gateway_tags,
    {
      Name = "${local.resource_name}" #expense-dev
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw] # This is explicit dependency
}

################## Public Route Table #####################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge (
    var.common_tags,
    var.public_route_table_tags,
    {
      Name = "${local.resource_name}-public" #expense-dev-public
    }
  )
}

################## Private Route Table #####################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge (
    var.common_tags,
    var.private_route_table_tags,
    {
      Name = "${local.resource_name}-private" #expense-dev-private
    }
  )
}

################## Database Route Table #####################
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge (
    var.common_tags,
    var.database_route_table_tags,
    {
      Name = "${local.resource_name}-database" #expense-dev-database
    }
  )
}

###### Routes #####################
###### Public Route ###############
resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

###### Private Route ###############
resource "aws_route" "private_route_nat" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

###### Database Route ###############
resource "aws_route" "database_route_nat" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

####### Route table and subnet association ######
####### public association ###########
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

####### private association ###########
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

####### database association ###########
resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidrs)
  subnet_id      = element(aws_subnet.database[*].id, count.index)
  route_table_id = aws_route_table.database.id
}  