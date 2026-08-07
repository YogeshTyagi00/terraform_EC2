#key pair
resource "aws_key_pair" "my_key" {
  key_name   = "my-key"
  public_key = file("tera-ec2-key.pub")
}

#vpc and security group
resource "aws_default_vpc" "default" {

}

resource "aws_security_group" "my_security_group"{
    name        = "my-security-group"
    description = "Allow SSH, HTTP and web traffic"
    vpc_id      = aws_default_vpc.default.id
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSH open"
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "http open"
    }
    ingress {
        from_port   = 8000
        to_port     = 8000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "web open"
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "my_instance"{
    key_name = aws_key_pair.my_key.key_name
    vpc_security_group_ids = [aws_security_group.my_security_group.id]
    instance_type = "t3.micro"
    ami = "ami-01f9e32add5a43171"
    root_block_device {
        volume_size = 10
        volume_type = "gp3"
    }
    tags = {
        Name = "my_instance"
    }
}