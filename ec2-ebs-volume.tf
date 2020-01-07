
# Create a new instance of the latest Ubuntu 14.04 on an
# t2.micro node with an AWS Tag naming it "HelloWorld"
provider "aws" {
  region = "eu-central-1"
}

data "aws_ami" "example" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# create EBS volume
resource "aws_ebs_volume" "example" {
  availability_zone = "eu-central-1"
  size              = 1
}

#create EC2 Instance
resource "aws_instance" "web" {
  ami           = "ami-010fae13a16763bb4"
  #ami           = "${data.aws_ami.amazon-linux-2.id}"
  instance_type = "t2.large"
  availability_zone = "eu-central-1b"

  tags = {
    Name        = "NY-test-EC2"
    Environment = "Sandbox",
    Owner       = "Narendra Yalavarthi"
  }
}

#attach EBS volume to EC2 instance
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.example.id}"
  instance_id = "${aws_instance.web.id}"
}

output "amiids" {
  value = "${data.aws_ami.example.id}"
}
