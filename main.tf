provider "aws" {
  region = "ap-southeast-1"
}
resource "aws_instance" "webhi" {
#count = 2
ami           = "ami-047126e50991d067b"
  instance_type = "t2.micro"
   key_name     = "oct4"
  tags = {
    Name = "HelloWorld"
  }
}
#resource "aws_ebs_volume" "webvolume1" {
#availability_zone = aws_instance.webhi.availability_zone
#size      = 10
#}

output "instance_id" {
 value = aws_instance.webhi.id
}
#output "volume_id" {
#value = aws_ebs_volume.webvolume1.id
#}

#resource "aws_volume_attachment" "ebs_att" {
#  device_name = "/dev/xvdg"
 # volume_id   = aws_ebs_volume.webvolume1.id
  #instance_id = aws_instance.webhi.id
#}

resource "aws_vpc" "mainvpc" {
  cidr_block       = "10.0.0.0/25"
  instance_tenancy = "default"

  tags = {
    Name = "mainvpc"
  }
}


resource "aws_subnet" "mainsubnet" {
#count = 2
  vpc_id     = aws_vpc.mainvpc.id
  cidr_block = "10.0.1.0/28"
availability_zone = aws_instance.webhi.availability_zone
  tags = {
    Name = "Mainsubnet"
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.mainvpc.id

  tags = {
    Name = "maingw"
  }
}


resource "aws_route_table" "mainroute" {
  vpc_id = aws_vpc.mainvpc.id
  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.mainsubnet.id
  route_table_id = aws_route_table.mainroute.id
}
