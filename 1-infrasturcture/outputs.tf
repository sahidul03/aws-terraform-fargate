output "vpc_id" {
  value = aws_vpc.production_vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.production_vpc.cidr_block
}

output "public_subnet_1_id" {
  value = aws_subnet.public_subnet_1.id
}

output "public_subnet_2_id" {
  value = aws_subnet.public_subnet_2.id
}

output "private_subnet_1_id" {
  value = aws_subnet.private_subnet_1.id
}

output "private_subnet_2_id" {
  value = aws_subnet.private_subnet_2.id
}

# data "aws_subnet_ids" "prodcution_public_subnet_ids" {
#   vpc_id = aws_vpc.production_vpc.id

#    tags = {
#     Type = "Public"
#   }
# }

# data "aws_subnet" "prodcution_public_subnet" {
#   for_each = data.aws_subnet_ids.prodcution_public_subnet_ids.ids
#   id       = each.value
# }

# output "public_subnet_cidr_blocks" {
#   value = [for s in data.aws_subnet.prodcution_public_subnet : s.cidr_block]
# }

# output "public_subnet_ids" {
#   value = [for s in data.aws_subnet.prodcution_public_subnet : s.id]
# }

# data "aws_subnet_ids" "prodcution_private_subnet_ids" {
#   vpc_id = aws_vpc.production_vpc.id

#    tags = {
#     Type = "Public"
#   }
# }

# data "aws_subnet" "prodcution_private_subnet" {
#   for_each = data.aws_subnet_ids.prodcution_private_subnet_ids.ids
#   id       = each.value
# }

# output "private_subnet_cidr_blocks" {
#   value = [for s in data.aws_subnet.prodcution_private_subnet : s.cidr_block]
# }

# output "private_subnet_ids" {
#   value = [for s in data.aws_subnet.prodcution_private_subnet : s.id]
# }