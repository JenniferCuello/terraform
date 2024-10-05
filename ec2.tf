
# Crea primera instancia EC2
resource "aws_instance" "example" {
  ami           = "ami-0d081196e3df05f4d" # AMI para una instancia Amazon Linux 2
  instance_type = "t2.micro"              # Tipo de instancia
  subnet_id               = aws_subnet.public_subnet_1.id
  vpc_security_group_ids  = [aws_security_group.instance_sg.id]  
  key_name = "cloud2"
  associate_public_ip_address = true
  user_data = var.ec2_command

  tags = {
    Name = "Terraform-EC2"
  }
}

# Crea segunda instancia EC2
resource "aws_instance" "example2" {
  ami           = "ami-0d081196e3df05f4d" # AMI para una instancia Amazon Linux 2
  instance_type = "t2.micro"              # Tipo de instancia
  subnet_id               = aws_subnet.public_subnet_2.id
  vpc_security_group_ids  = [aws_security_group.instance_sg.id]  
  key_name = "cloud2"
  associate_public_ip_address = true
  user_data = var.ec2_command

  tags = {
    Name = "Terraform-2-EC2"
  }
}


# Salida con la IP pública de la instancia
output "instance_public_ip" {
  value = aws_instance.example.public_ip
}
