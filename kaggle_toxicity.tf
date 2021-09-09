resource "aws_s3_bucket" "models" {
  bucket = "toxicity-models"
  force_destroy = true
}

resource "aws_instance" "kaggle_toxicity" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.aws_key_name

  vpc_security_group_ids      = [aws_security_group.vpc_sg.id]
  subnet_id                   = aws_subnet.eu-west-1a-public.id
  associate_public_ip_address = true

  root_block_device {
    volume_size = 150
  }

  provisioner "file" {
    source      = "aws/model/hyperparams_cnn.json"
    destination = "/home/ubuntu/hyperparams_cnn.json"

    connection {
      host        = coalesce(self.public_ip, self.private_ip)
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("aws/keys/toxicity.pem")
      agent       = "false"
      timeout     = "3m"
    }
  }

  provisioner "file" {
    source      = "aws/model/hyperparams_lstm.json"
    destination = "/home/ubuntu/hyperparams_lstm.json"

    connection {
      host        = coalesce(self.public_ip, self.private_ip)
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("aws/keys/toxicity.pem")
      agent       = "false"
      timeout     = "3m"
    }
  }

  provisioner "file" {
    source      = "aws/s3/config"
    destination = "/home/ubuntu/config"

    connection {
      host        = coalesce(self.public_ip, self.private_ip)
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("aws/keys/toxicity.pem")
      agent       = "false"
      timeout     = "3m"
    }
  }

  provisioner "file" {
    source      = "aws/s3/credentials"
    destination = "/home/ubuntu/credentials"

    connection {
      host        = coalesce(self.public_ip, self.private_ip)
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("aws/keys/toxicity.pem")
      agent       = "false"
      timeout     = "3m"
    }
  }

  provisioner "remote-exec" {
    script = "scripts/prepare_instance.sh"

    connection {
      host        = coalesce(self.public_ip, self.private_ip)
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("aws/keys/toxicity.pem")
      agent       = "false"
      timeout     = "1m"
    }
  }
}

resource "aws_eip" "ip" {
  instance = aws_instance.kaggle_toxicity.id
}

output "ip" {
  value = aws_eip.ip.public_ip
}
