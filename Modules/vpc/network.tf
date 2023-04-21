############
# VPC      #
############
resource "aws_vpc" "vpc" {
    cidr_block                     = var.vpc_cidr
    enable_classiclink             = var.vpc_enable_classiclink
    enable_classiclink_dns_support = var.vpc_enable_classiclink_dns_support
    enable_dns_hostnames           = var.vpc_enable_dns_hostnames
    enable_dns_support             = var.vpc_dns_support

    tags = {
        Name      = "${var.env}-vpc"
        CreatedBy = "Terraform"
    }
}

###########
# Subnets #
###########
resource "aws_subnet" "ecs_private_subnets" {
    count               = var.vpc_private_subnets_count
    vpc_id              = aws_vpc.vpc.id
    cidr_block          = "${split(".", var.vpc_cidr)[0]}.${split(".", var.vpc_cidr)[1]}.${count.index + 1}.0/24"
    availability_zone   = "${element(data.aws_availability_zones.aws_azs.names, count.index)}"

    depends_on = [
        aws_vpc.vpc
    ]

    tags = {
        Name      = "${var.env}-ecs-private_subnet-${count.index + 1}"
        CreatedBy = "Terraform"
    }
}

resource "aws_subnet" "ecs_public_subnets" {
    count             = var.vpc_public_subnets_count
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = "${split(".", var.vpc_cidr)[0]}.${split(".", var.vpc_cidr)[1]}.${count.index + 1 + var.vpc_private_subnets_count}.0/24"
    availability_zone = "${element(data.aws_availability_zones.aws_azs.names, (count.index + length(data.aws_availability_zones.aws_azs.names)))}"

    depends_on = [
        aws_vpc.vpc
    ]

    tags = {
        Name      = "${var.env}-ecs-public_subnet-${count.index + 1}"
        CreatedBy = "Terraform"
    }
}


############
# Gateway  #
############
resource "aws_internet_gateway" "ecs_internet_gateway" {
    vpc_id = aws_vpc.vpc.id

    depends_on = [
        aws_vpc.vpc
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
    vpc_id  = aws_vpc.vpc.id
    route {
        cidr_block  = "0.0.0.0/0"
        gateway_id  = aws_internet_gateway.ecs_internet_gateway.id
    }

    tags = {
        Name        = "${var.env}-ecs-public_routing_table"
        CreatedBy   = "Terraform"
    }
}

resource "aws_route_table" "ecs_private_routing_table" {
    vpc_id  = aws_vpc.vpc.id
    route {
        cidr_block      = "0.0.0.0/0"
        nat_gateway_id  = aws_nat_gateway.ecs_private_nat_gw.id
    }

    tags = {
        Name        = "${var.env}-ecs-private_routing_table"
        CreatedBy   = "Terraform"
    }
}

# TODO: Implement diabling of public routing
resource "aws_route_table_association" "rt_private_association" {
    count          = var.vpc_enable_gateway ? var.vpc_private_subnets_count : 0
    subnet_id      = element(aws_subnet.ecs_private_subnets.*.id, count.index)
    route_table_id = aws_route_table.ecs_private_routing_table.id

    depends_on  = [
        aws_route_table.ecs_private_routing_table
    ]
}

resource "aws_route_table_association" "rt_public_association" {
    count          = var.vpc_public_subnets_count
    subnet_id      = element(aws_subnet.ecs_public_subnets.*.id, count.index)
    route_table_id = aws_route_table.ecs_public_routing_table.id
}

############
# DHCP     #
############
resource "aws_vpc_dhcp_options" "ecs_private_subnet_dhcp_options" {
    domain_name         = "ec2.internal"
    domain_name_servers = ["AmazonProvidedDNS"]
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
    vpc_id          = aws_vpc.vpc.id
    dhcp_options_id = aws_vpc_dhcp_options.ecs_private_subnet_dhcp_options.id
}
