resource "aws_alb" "openvpn-lb" {
  name            = "openvpn-lb"
  subnets         = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  security_groups = [aws_security_group.lb-sg.id]

  tags = {
    Name = "openvpn-lb"
  }
}

resource "aws_alb_target_group" "openvpn-tg" {
    name = "openvpn-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = "${aws_vpc.main.id}" 

    health_check {
        path                = "/"
        port                = 80
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200"
  }
}

resource "aws_alb_target_group_attachment" "openvpn-tg-attachment" {
    target_group_arn = "${aws_alb_target_group.openvpn-tg.arn}"
    target_id = "${aws_instance.openvpn-app.id}"
    port = 80
}

resource "aws_alb_listener" "http_listener" { 
    load_balancer_arn = "${aws_alb.openvpn-lb.arn}" 
    port = "80"   

    default_action {
      type          = "redirect"
      redirect {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_alb.openvpn-lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.app_certificate.arn
  default_action {   
        target_group_arn = "${aws_alb_target_group.openvpn-tg.arn}"
        type = "forward"   
  } 
}
