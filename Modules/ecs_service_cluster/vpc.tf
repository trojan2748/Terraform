############
# VPC      #
############
resource "aws_vpc" "main_vpc" {
    cidr_block                     = var.vpc_cidr
    enable_dns_support             = true
    enable_dns_hostnames           = true

    tags = {
        Name      = "${var.env}-service"
        CreatedBy = "Terraform"
    }
}


############
# Gateway  #
############
resource "aws_internet_gateway" "ecs_internet_gateway" {
    vpc_id = aws_vpc.main_vpc.id

    depends_on = [
        aws_vpc.main_vpc
    ]

    tags = {
        Name      = "${var.env}-ecs-internet_gateway"
        CreatedBy = "Terraform"
    }
}


############
# EIP      #
############
resource "aws_eip" "ecs_nat_gw_eip" {
    vpc = true

    tags = {
        Name      = "${var.env}-ecs_service-nat_gw_eip"
        CreatedBy = "Terraform"
    }
}


###################
# Private Subnets #
###################
resource "aws_subnet" "ecs_private_subnets" {
    count               = length(data.aws_availability_zones.aws_azs.names)
    vpc_id              = aws_vpc.main_vpc.id
    cidr_block          = "${split(".", var.vpc_cidr)[0]}.${split(".", var.vpc_cidr)[1]}.${count.index + 1}.0/24"
    availability_zone   = "${element(data.aws_availability_zones.aws_azs.names, count.index)}"

    depends_on = [
        aws_vpc.main_vpc
    ]

    tags = {
        Name      = "${var.env}-ecs-private_subnet-${count.index + 1}"
        CreatedBy = "Terraform"
    }
}


#################
# Public Subnet #
#################
resource "aws_subnet" "ecs_public_subnets" {
    count               = length(data.aws_availability_zones.aws_azs.names)
    vpc_id              = aws_vpc.main_vpc.id
    cidr_block          = "${split(".", var.vpc_cidr)[0]}.${split(".", var.vpc_cidr)[1]}.${length(data.aws_availability_zones.aws_azs.names) + count.index + 1}.0/24"
    availability_zone   = "${element(data.aws_availability_zones.aws_azs.names, count.index)}"

    depends_on = [
        aws_vpc.main_vpc
    ]

    tags = {
        Name      = "${var.env}-ecs-public_subnet-${count.index + 1}"
        CreatedBy = "Terraform"
    }
}


############
# NAT GW   #
############
resource "aws_nat_gateway" "ecs_private_nat_gw" {
    allocation_id     = aws_eip.ecs_nat_gw_eip.id
    subnet_id         = aws_subnet.ecs_public_subnets.0.id

    depends_on = [
        aws_subnet.ecs_public_subnets,
        aws_eip.ecs_nat_gw_eip
    ]

    tags = {
        Name      = "${var.env}-ecs-private_nat_gateway"
        CreatedBy = "Terraform"
    }
}



############
# Routing  #
############
resource "aws_route_table" "ecs_public_routing_table" {
    vpc_id = aws_vpc.main_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ecs_internet_gateway.id
    }

    tags = {
        Name      = "${var.env}-ecs-public_routing_table"
        CreatedBy = "Terraform"
    }
}

resource "aws_route_table" "ecs_private_routing_table" {
    vpc_id = aws_vpc.main_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.ecs_private_nat_gw.id
    }

    tags = {
        Name      = "${var.env}-ecs-private_routing_table"
        CreatedBy = "Terraform"
    }
}

resource "aws_route_table_association" "rt_private_association" {
    count          = var.az_count
    subnet_id      = element(aws_subnet.ecs_private_subnets.*.id, count.index)
    route_table_id = aws_route_table.ecs_private_routing_table.id
}

resource "aws_route_table_association" "rt_public_association" {
    count          = var.az_count
    subnet_id      = element(aws_subnet.ecs_public_subnets.*.id, count.index)
    route_table_id = aws_route_table.ecs_public_routing_table.id
}
