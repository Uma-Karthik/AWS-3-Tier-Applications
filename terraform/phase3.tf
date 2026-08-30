data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Launch Template

resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-app-"
  image_id      = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.app.id
  ]

  user_data = base64encode(<<-EOF
    #!/bin/bash

    dnf install -y python3

    mkdir -p /home/ec2-user/app

    cat > /home/ec2-user/app/index.html <<'HTML'
    <!DOCTYPE html>
    <html>
    <head>
        <title>AWS 3-Tier Application</title>
    </head>
    <body>
        <h1>AWS 3-Tier Architecture</h1>
        <h2>Application Server is Running</h2>
        <p>Deployed using Terraform + EC2 + Auto Scaling + ALB</p>
    </body>
    </html>
    HTML

    cat > /etc/systemd/system/app.service <<'SERVICE'
    [Unit]
    Description=3-Tier Demo Application
    After=network.target

    [Service]
    Type=simple
    User=ec2-user
    WorkingDirectory=/home/ec2-user/app
    ExecStart=/usr/bin/python3 -m http.server 8080 --directory /home/ec2-user/app
    Restart=always

    [Install]
    WantedBy=multi-user.target
    SERVICE

    systemctl daemon-reload
    systemctl enable app
    systemctl start app
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-app-server"
      Tier = "Application"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Target Group

resource "aws_lb_target_group" "app" {
  name     = "${var.project_name}-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  target_type = "instance"

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    port                = "8080"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name = "${var.project_name}-target-group"
    Tier = "Application"
  }
}

# Create Application Load Balancer

resource "aws_lb" "app" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    aws_subnet.public_az1.id,
    aws_subnet.public_az2.id
  ]

  tags = {
    Name = "${var.project_name}-alb"
    Tier = "LoadBalancer"
  }
}

# Create ALB Listener

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  tags = {
    Name = "${var.project_name}-http-listener"
  }
}

# Create Auto Scaling Group

resource "aws_autoscaling_group" "app" {
  name = "${var.project_name}-asg"

  min_size         = 2
  desired_capacity = 2
  max_size         = 4

  vpc_zone_identifier = [
    aws_subnet.app_az1.id,
    aws_subnet.app_az2.id
  ]

  target_group_arns = [
    aws_lb_target_group.app.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-app-server"
    propagate_at_launch = true
  }

  tag {
    key                 = "Tier"
    value               = "Application"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

