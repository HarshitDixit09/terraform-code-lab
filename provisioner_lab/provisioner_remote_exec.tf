provider "aws" {
  region = "ap-south-1"
}
resource "aws_instance" "myec2" {
  ami           = "ami-0da59f1af71ea4ad2"
  instance_type = "t2.micro"
  key_name      = "terraform-key"


  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/root/terraform-key.pem")
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install -y nginx1",
      "sudo systemctl start nginx1"
    ]
  }

}

