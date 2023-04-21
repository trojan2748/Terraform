###############
# Public ALBs #
###############
resource "aws_alb" "public_alb" {
    name            = "${var.env}-public-alb-1"
    subnets         = "${aws_subnet.ecs_public_subnets.*.id}"
    security_groups = ["${aws_security_group.ecs_loadbalancers_sg.id}"]

    depends_on      = [
        aws_subnet.ecs_public_subnets
    ]

    tags            = {
        Name        = "${var.env}-public-alb"
    }
}

################
# Private ALBs #
################
resource "aws_alb" "private_alb" {
    count           = var.alb_count
    name            = "${var.env}-service-private-alb-${count.index +1}"
    subnets         = "${aws_subnet.ecs_private_subnets.*.id}"
    security_groups = ["${aws_security_group.ecs_loadbalancers_sg.id}"]

    depends_on      = [
        aws_subnet.ecs_private_subnets
    ]

    tags            = {
        Name        = "${var.env}-private-alb-${count.index + 1}"
    }

}
