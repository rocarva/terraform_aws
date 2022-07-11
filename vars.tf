# variaveis de imagens 

variable "amis" {
  type    = map(string)
  default = {
    "us-east-1" = "ami-052efd3df9dad4825"
    "us-east-2" = "ami-02d1e544b84bf7502"
  }
}

variable "cidrs_acesso_remoto" {
  type = list
  default = ["177.23.122.240/32","177.23.122.240/32"]
}

variable "key_name" {
  default = "terraform-aws"
}

variable "instance_type" {
  default = "t2.micro"
}