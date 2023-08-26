provider "aws" {
    region = "ap-south-1"
}

variable "test"{}

resource "aws_instance" "myec2" {
    ami = "123"
    instance_type = "t2.micro"
    count = var.test == true ? 1 : 0
}

resource "aws_instance" "mysecondec2" {
    ami = "567"
    instance_type = "t2.large"
    count = var.test == false ? 1 :0
}
