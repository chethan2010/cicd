resource "aws_key_pair" "vpn" {
  key_name   = "jenkins"
  # you can paste the public key directly like this
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAVOVEfSZEvhDHtqiaeuuKOAb1O3ZfoO2IOp8ux/zCEl hp@DESKTOP-CVSHAG8"
  # public_key = file("~/.ssh/openvpn.pub")
  # ~ means windows home directory
}

module "jenkins" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  key_name = aws_key_pair.vpn.public_key
  name = "jenkins-tf"
  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-02b46bf3da815a952"]
  subnet_id = "subnet-04093fa40f500aed6"
  ami = data.aws_ami.ami_info.id
  user_data = file("jenkins.sh")
  tags = {
    
        Name = "jenkins-Master"
}
}


module "jenkins-agent" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  key_name = aws_key_pair.vpn.public_key
  name = "jenkins-tf"

  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-02b46bf3da815a952"]
  subnet_id = "subnet-04093fa40f500aed6"
  ami = data.aws_ami.ami_info.id
  user_data = file("jenkins-agent.sh")
  tags = {
        Name = "jenkins-agent"
    }
}


# module "nexus" {
#      source  = "terraform-aws-modules/ec2-instance/aws"
#   name = "nexus"

#   instance_type          = "t3.medium"
#   vpc_security_group_ids = ["sg-08f131185f8967295"]
#   subnet_id = "subnet-0ca01a6ab094ac6da"
#   ami = data.aws_ami.nexus_ami_info.id
#   key_name = aws_key_pair.tools.key_name
#    root_block_device = [
#     {
#       volume_type = "gp3"
#       volume_size = 30
#     }
#   ]
#   tags = {
#     Name = "nexus"
#   }
# }

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name =var.zone_name
  
  records = [
    {
      name    = "jenkins"
      type    = "A"
      ttl = 1
      records = [
        module.jenkins.public_ip
      ]
    },
    {
      name    = "jenkins-agent"
      type    = "A"
      ttl = 1
      records = [
        module.jenkins-agent.private_ip
      ]
    }
    #  {
    #   name    = "nexus"
    #   type    = "A"
    #   ttl     = 1
    #   allow_overwrite = true
    #   records = [
    #     module.nexus.private_ip
    #   ]
    #   allow_overwrite = true
    # }

  ]
}



# resource "aws_security_group" "allow_tls" {
#   # name        = "allow jenkins"
#   # description = "jenkins_port"
#   # vpc_id      = var.vpc_id
#     ingress {
#         from_port        = 8080
#         to_port          = 8080
#         protocol         = "tcp"
#         cidr_blocks      = ["0.0.0.0/0"]
#     }

#     egress {
#         from_port        = 0 # from 0 to 0 means, opening all protocols
#         to_port          = 0
#         protocol         = "-1" # -1 all protocols
#         cidr_blocks      = ["0.0.0.0/0"]
#     }

#        tags = {
#         Name = "allow_jenkins"
#         CreatedBy = "Hemanth"
#     }

# }
