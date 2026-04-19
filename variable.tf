variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "image" {
  default = "debian-cloud/debian-11"
}

#variable "machine_type" {
#  type = map
#  default = {
#    "dev" = "e2-small"
#    "prod" = "e2-medium"
#  }  
#}

variable "machine_type" {
  default = "e2-medium" 
}

variable "environment"{
  default = "test"
}

variable "machine_type_dev"{
  default = "e2-small"
}

variable "instance_names" {
  default = "vm1"
}

#variable "instance_names" {
#  type    = list(string)
#  default = ["vm1", "vm2"]
#}
variable "user_password" {
    sensitive = true
}