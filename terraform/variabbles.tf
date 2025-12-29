variable "vpc-a-cicd" {
  default = "10.0.0.0/16"
}

variable "vpc-b-cicd" {
  default = "10.1.0.0/16"
}


variable "sub-a-cicd" {
  default = "10.0.1.0/24"
}

variable "sub-b-cicd" {
  default = "10.1.1.0/24"
}

variable "peer_owner_id" {
  default = "852335442799"
}

variable "ami" {
    type = string
    default = "ami-0ecb62995f68bb549"
  
}