# configuração provedor
provider "aws"{
    #version = "~> 3.0"
    region = "us-east-1"
}

provider "aws"{
    alias = "us-east-2"
    #version = "~> 3.0"
    region = "us-east-2"
}


# recursos 
# levandtando 3 maquinas com esse ami e esse time de instancia 
resource "aws_instance" "dev"{
    count = 3
    ami = var.amis["us-east-1"]
    instance_type = var.instance_type
    key_name = var.key_name
    # informando que o nome da maquina sera dev + a contagem
    tags = {
        Name ="dev${count.index}"
    }
    # adicionando o security group 
    # vpc_security_group_ids = ["sg-0adcbc8d367dc1b04"] # é o id do grupo 
    vpc_security_group_ids = ["${aws_security_group.acesso_ssh.id}"]
}


resource "aws_instance" "dev4"{
    ami = var.amis["us-east-1"]
    instance_type = var.instance_type
    key_name = var.key_name
    # informando que o nome da maquina sera dev + a contagem
    tags = {
        Name ="dev4"
    }    
    vpc_security_group_ids = ["${aws_security_group.acesso_ssh.id}"]
    depends_on = [aws_s3_bucket.dev4]
}

resource "aws_instance" "dev5"{
    ami = var.amis["us-east-1"]
    instance_type = var.instance_type
    key_name = var.key_name
    # informando que o nome da maquina sera dev + a contagem
    tags = {
        Name ="dev5"
    }    
    vpc_security_group_ids = ["${aws_security_group.acesso_ssh.id}"]
}


## recurso s3 

resource "aws_s3_bucket" "dev4" {
  bucket = "rcarvalholabs-dev4"
#  acl = "private" deprecated 
  tags = {
    Name = "rcarvalholabs-dev4"    
  }
}


# colocando em outra regiao 

resource "aws_instance" "dev6"{
    provider = aws.us-east-2
    ami = var.amis["us-east-2"]
    instance_type = var.instance_type
    key_name = var.key_name
    # informando que o nome da maquina sera dev + a contagem
    tags = {
        Name ="dev6"
    }    
    vpc_security_group_ids = ["${aws_security_group.acesso_ssh-us-east-2.id}"]
    # implementando a dependencia do banco de dados dynamodb
    depends_on =[aws_dynamodb_table.dynamodb-homologacao]
}

# dynamodb 

resource "aws_dynamodb_table" "dynamodb-homologacao" {
  provider = aws.us-east-2
  name           = "GameScores"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "UserId"
  range_key      = "GameTitle"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "GameTitle"
    type = "S"
  }
}


resource "aws_instance" "dev7"{
    provider = aws.us-east-2
    ami = var.amis["us-east-2"]
    instance_type = var.instance_type
    key_name = "${var.key_name}"
    # informando que o nome da maquina sera dev + a contagem
    tags = {
        Name ="dev7"
    }    
    vpc_security_group_ids = ["${aws_security_group.acesso_ssh-us-east-2.id}"]    
    
}

## recurso s3 

resource "aws_s3_bucket" "homologacao" {
  bucket = "rcarvalholabs-homologacao"
#  acl = "private" deprecated 
  tags = {
    Name = "rcarvalholabs-homologacao"    
  }
}