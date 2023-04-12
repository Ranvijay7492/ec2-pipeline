resource "aws_vpc" "ranvijay-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(
    {
      Name = var.name
    }
  )
}
resource "aws_internet_gateway" "ranvijay-gw" {
  vpc_id = aws_vpc.ranvijay-vpc.id
  tags = merge({
    Name = "${var.name}-IGW"
  })
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.ranvijay-vpc.id
  cidr_block        = var.public_subnets
#  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = merge({
    Name = "${var.name}-pub-subnet"
  })
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ranvijay-vpc.id
  tags = merge({
    Name = "${var.name}-public-rt"
  })
}
resource "aws_route" "ranvijay-gw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ranvijay-gw.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
