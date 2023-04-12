output "id" {
  value = aws_vpc.ranvijay-vpc.id
}
output "cidr" {
  value = aws_vpc.ranvijay-vpc.cidr_block
}
output "public_subnets" {
  value = aws_subnet.public
}
output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}
output "public_route_table_ids" {
  value = aws_route_table.public.*.id
}