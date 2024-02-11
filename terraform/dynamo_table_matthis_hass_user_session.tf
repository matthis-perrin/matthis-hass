output "matthis_hass_user_session_table_name" {
  value       = aws_dynamodb_table.matthis_hass_user_session_table.name
}

output "matthis_hass_user_session_index_name" {
  value = {
    for obj in aws_dynamodb_table.matthis_hass_user_session_table.global_secondary_index : "${aws_dynamodb_table.matthis_hass_user_session_table.name }_By_${obj.hash_key}${ length(obj.range_key) > 0 ? "_Sorted_By_${obj.range_key}" : "" }" => obj.name
  }
}

resource "aws_dynamodb_table" "matthis_hass_user_session_table" {
  name           = "MatthisHassUserSession"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "token"

  attribute {
    name = "token"
    type = "S"
  }

  ttl {
    attribute_name = "expiresAt"
    enabled = true
  }

}