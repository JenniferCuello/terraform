# Configuración del proveedor de AWS
provider "aws" {
  region     = "us-west-2"
}

# Creación de la VPC
resource "aws_vpc" "cloud_vpc" {
  cidr_block = "70.0.0.0/16"  # Rango de IP para la VPC
  enable_dns_support = true    # Habilitar soporte DNS
  enable_dns_hostnames = true   # Habilitar nombres de host DNS

  tags = {
    Name = "cloud_vpc"         # Etiqueta para la VPC
  }
}

# Subredes públicas

# Primera subred pública
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.cloud_vpc.id  # ID de la VPC donde se crea la subred
  cidr_block        = "70.0.1.0/24"           # Rango de IP para la subred pública 1
  availability_zone = "us-west-2a"            # Zona de disponibilidad

  tags = {
    Name = "public1"  # Etiqueta para la subred pública 1
  }
}

# Segunda subred pública
resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.cloud_vpc.id  # ID de la VPC donde se crea la subred
  cidr_block        = "70.0.2.0/24"           # Rango de IP para la subred pública 2
  availability_zone = "us-west-2b"            # Zona de disponibilidad

  tags = {
    Name = "public2"  # Etiqueta para la subred pública 2
  }
}

# Subredes privadas

# Primera subred privada
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.cloud_vpc.id  # ID de la VPC donde se crea la subred
  cidr_block        = "70.0.3.0/24"           # Rango de IP para la subred privada 1
  availability_zone = "us-west-2c"            # Zona de disponibilidad

  tags = {
    Name = "private1" # Etiqueta para la subred privada 1
  }
}

# Segunda subred privada
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.cloud_vpc.id  # ID de la VPC donde se crea la subred
  cidr_block        = "70.0.4.0/24"           # Rango de IP para la subred privada 2
  availability_zone = "us-west-2d"            # Zona de disponibilidad

  tags = {
    Name = "private2" # Etiqueta para la subred privada 2
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cloud_vpc.id  # ID de la VPC a la que se asocia el gateway

  tags = {
    Name = "inter_gateway"    # Etiqueta para el Internet Gateway
  }
}

# Tabla de enrutamiento para subredes públicas
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.cloud_vpc.id  # ID de la VPC a la que pertenece la tabla de enrutamiento

  route {
    cidr_block = "0.0.0.0/0"        # Ruta para todo el tráfico saliente
    gateway_id = aws_internet_gateway.igw.id  # ID del Internet Gateway
  }

  tags = {
    Name = "terraform_route_table"    # Etiqueta para la tabla de enrutamiento pública
  }
}

# Asociación de la tabla de enrutamiento a la subred pública 1
resource "aws_route_table_association" "public_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id  # ID de la subred pública 1
  route_table_id = aws_route_table.public_rt.id    # ID de la tabla de enrutamiento pública
}

# Asociación de la tabla de enrutamiento a la subred pública 2
resource "aws_route_table_association" "public_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id  # ID de la subred pública 2
  route_table_id = aws_route_table.public_rt.id    # ID de la tabla de enrutamiento pública
}

# Security Group (Allow all outgoing traffic for instances)
resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.cloud_vpc.id

  ingress{
    from_port   = 22
    to_port     = 22
    protocol    = "tcp" # Allows all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
    
  }
    ingress{
    from_port   = 80
    to_port     = 80
    protocol    = "tcp" # Allows all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
    
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allows all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance_security_group"
  }
}
