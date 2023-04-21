###################################################################################################################################
#VPC
###################################################################################################################################

resource "aws_vpc" "app_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name            = "${local.environment_prefix}-vpc"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "LMS"
    BillingSubGroup = "Vpc"
    Environment     = "${local.environment_prefix}"
    CreatedBy       = "SRETeam@glidewelldental.com"
  }

}

###################################################################################################################################
#database subnets
###################################################################################################################################

resource "aws_subnet" "database_subnets" {
  count             = var.create ? length(var.database_subnets_cidr) : 0
  vpc_id            = aws_vpc.app_vpc.id
  availability_zone = var.azs[count.index]
  cidr_block        = var.database_subnets_cidr[count.index]

  tags = {
    Name            = "${local.environment_prefix}-database-subnet-${count.index + 1}"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "LMS"
    BillingSubGroup = "Subnet"
    Environment     = "${local.environment_prefix}"
    CreatedBy       = "SRETeam@glidewelldental.com"
    Tier            = "Private"
  }
}

###################################################################################################################################
#Private subnets
###################################################################################################################################

resource "aws_subnet" "app_private_subnets" {
  count             = var.create ? length(var.private_subnets_cidr) : 0
  vpc_id            = aws_vpc.app_vpc.id
  availability_zone = var.azs[count.index]
  cidr_block        = var.private_subnets_cidr[count.index]

  tags = {
    Name            = "${local.environment_prefix}-private-subnet-${count.index + 1}"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "LMS"
    BillingSubGroup = "Subnet"
    Environment     = "${local.environment_prefix}"
    CreatedBy       = "SRETeam@glidewelldental.com"
    Tier            = "Private"
  }
}

###################################################################################################################################
#Pubic subnets
###################################################################################################################################

resource "aws_subnet" "app_public_subnets" {
  count                   = var.create ? length(var.public_subnets_cidr) : 0
  vpc_id                  = aws_vpc.app_vpc.id
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true
  cidr_block              = var.public_subnets_cidr[count.index]

  tags = {
    Name            = "${local.environment_prefix}-public-subnet-${count.index + 1}"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "LMS"
    BillingSubGroup = "Subnet"
    Environment     = "${local.environment_prefix}"
    CreatedBy       = "SRETeam@glidewelldental.com"
    Tier            = "Public"
  }
}

###################################################################################################################################
#IGW
###################################################################################################################################

resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name            = "${local.environment_prefix}-igw"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "LMS"
    BillingSubGroup = "InternetGateway"
    Environment     = "${local.environment_prefix}"
    CreatedBy       = "SRETeam@glidewelldental.com"
  }
}

###################################################################################################################################
#Route table for public subnet
###################################################################################################################################

resource "aws_route_table" "app_public_rtable" {
  count  = var.create ? length(var.public_subnets_cidr) : 0
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }

  route {
    cidr_block         = "192.168.128.0/19" # ClientVPN route - this is the same in all envionments
    transit_gateway_id = var.transit_gateway_id  
  }

  tags = {
    Name            = "${local.environment_prefix}-public-route-table-${split("-", var.azs[count.index])[2]}"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "LMS"
    BillingSubGroup = "RouteTable"
    Environment     = "${local.environment_prefix}"
    CreatedBy       = "SRETeam@glidewelldental.com"
  }
  depends_on = [aws_internet_gateway.app_igw]
}

###################################################################################################################################
#Route table for private subnet
###################################################################################################################################

resource "aws_route_table" "app_private_rtable" {
  count  = var.create ? length(var.private_subnets_cidr) : 0
  vpc_id = aws_vpc.app_vpc.id


  route {
    cidr_block         = "192.168.128.0/19" # ClientVPN route - this is the same in all envionments
    transit_gateway_id = var.transit_gateway_id  
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.app_nat_gw[count.index].id
  }

  tags = {
    Name            = "${local.environment_prefix}-private-route-table-${split("-", var.azs[count.index])[2]}"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "LMS"
    BillingSubGroup = "RouteTable"
    Environment     = "${local.environment_prefix}"
    CreatedBy       = "SRETeam@glidewelldental.com"
  }

  depends_on = [aws_internet_gateway.app_igw]
}

###################################################################################################################################
#Route table for database subnet
###################################################################################################################################

resource "aws_route_table" "database_rtable" {
  count  = var.create ? length(var.database_subnets_cidr) : 0
  vpc_id = aws_vpc.app_vpc.id


  route {
    cidr_block         = "192.168.128.0/19" # ClientVPN route - this is the same in all envionments
    transit_gateway_id = var.transit_gateway_id 
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.app_nat_gw[count.index].id
  }

  tags = {
    Name            = "${local.environment_prefix}-database-route-table-${split("-", var.azs[count.index])[2]}"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "LMS"
    BillingSubGroup = "RouteTable"
    Environment     = "${local.environment_prefix}"
    CreatedBy       = "SRETeam@glidewelldental.com"
  }

  depends_on = [aws_internet_gateway.app_igw]
}


###################################################################################################################################
#Assign the route table to public subnets
###################################################################################################################################

resource "aws_route_table_association" "public-subnet-assn" {
  count          = var.create ? length(var.public_subnets_cidr) : 0
  subnet_id      = aws_subnet.app_public_subnets[count.index].id
  route_table_id = aws_route_table.app_public_rtable[count.index].id
}

###################################################################################################################################
#Assign the route table to private subnets
###################################################################################################################################

resource "aws_route_table_association" "private-subnet-assn" {
  count          = var.create ? length(var.private_subnets_cidr) : 0
  subnet_id      = aws_subnet.app_private_subnets[count.index].id
  route_table_id = aws_route_table.app_private_rtable[count.index].id
}

###################################################################################################################################
#Assign the route table to database subnets
###################################################################################################################################

resource "aws_route_table_association" "database-subnet-assn" {
  count          = var.create ? length(var.database_subnets_cidr) : 0
  subnet_id      = aws_subnet.database_subnets[count.index].id
  route_table_id = aws_route_table.database_rtable[count.index].id
}

###################################################################################################################################
#Public route 
###################################################################################################################################

resource "aws_route" "public_route" {
  count                  = var.create ? length(var.public_subnets_cidr) : 0
  route_table_id         = aws_route_table.app_public_rtable[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.app_igw.id
}

###################################################################################################################################
#private route 
###################################################################################################################################

resource "aws_route" "private_route" {
  count                  = var.create ? length(var.private_subnets_cidr) : 0
  route_table_id         = aws_route_table.app_private_rtable[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.app_nat_gw[count.index].id
}

###################################################################################################################################
#database route 
###################################################################################################################################

resource "aws_route" "database_route" {
  count                  = var.create ? length(var.database_subnets_cidr) : 0
  route_table_id         = aws_route_table.database_rtable[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.app_nat_gw[count.index].id
}

###################################################################################################################################
#EIP 
###################################################################################################################################

resource "aws_eip" "nat_eip" {
  count      = var.create ? length(var.private_subnets_cidr) : 0
  vpc        = true
  depends_on = [aws_internet_gateway.app_igw]

  tags = {
    Name            = "${local.environment_prefix}-eip-${count.index + 1}"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "LMS"
    BillingSubGroup = "ElasticIp"
    Environment     = "${local.environment_prefix}"
    CreatedBy       = "SRETeam@glidewelldental.com"
  }
}

###################################################################################################################################
#Public NAT Gateway
###################################################################################################################################

resource "aws_nat_gateway" "app_nat_gw" {
  count         = var.create ? length(var.public_subnets_cidr) : 0
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.app_public_subnets[count.index].id
  depends_on    = [ aws_internet_gateway.app_igw, aws_subnet.app_public_subnets ]

  tags = {
    Name            = "${local.environment_prefix}-nat-gateway-${count.index + 1}"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "LMS"
    BillingSubGroup = "NatGateway"
    Environment     = "${local.environment_prefix}"
    CreatedBy       = "SRETeam@glidewelldental.com"
  }
}

###################################################################################################################################
# Attach transit Gateway
###################################################################################################################################

resource "aws_ec2_transit_gateway_vpc_attachment" "public_transit_gateway_attachment" {
  subnet_ids         = aws_subnet.app_public_subnets[*].id
  transit_gateway_id = var.transit_gateway_id 
  vpc_id             = aws_vpc.app_vpc.id
  depends_on         = [aws_subnet.app_public_subnets]

  tags = {
    Name            = "ClientVPN-${var.transit_gateway_path}-${local.environment_prefix}-vpc (us-east-1)"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "LMS"
    BillingSubGroup = "TransitGatewayAttachment"
    Environment     = "${local.environment_prefix}"
    CreatedBy       = "SRETeam@glidewelldental.com"
  }
  
}
