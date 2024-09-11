module "jenkins" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "jenkins-tf"

  instance_type          = "t3.small"
  vpc_security_group_ids = ["sg-03413f9ed07877b90"]
  subnet_id = "subnet-0ca01a6ab094ac6da"
  ami = data.aws_ami.ami_info.id
  user_data = file("jenkins.sh")
  tags = {
    
        Name = "jenkins-tf"
}
}

module "jenkins-agent" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "jenkins-tf"

  instance_type          = "t3.small"
  vpc_security_group_ids = ["sg-03413f9ed07877b90"]
  subnet_id = "subnet-0ca01a6ab094ac6da"
  ami = data.aws_ami.ami_info.id
  user_data = file("jenkins-agent.sh")
  tags = {
        Name = "jenkins-agent"
    }
}


module "nexus" {
     source  = "terraform-aws-modules/ec2-instance/aws"
  name = "nexus"

  instance_type          = "t3.small"
  vpc_security_group_ids = ["sg-03413f9ed07877b90"]
  subnet_id = "subnet-0ca01a6ab094ac6da"
  ami = data.aws_ami.nexus_ami_info.id
  user_data = file("jenkins-agent.sh")
  tags = {
        Name = "jenkins-agent"
    }
  
}

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
    },
     {
      name    = "nexus"
      type    = "A"
      ttl = 1
      records = [
        module.nexus.private_ip
      ]
    }

  ]
}