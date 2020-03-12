# variable "git_branch" {
#   type = string
# }

# variable "git_commit" {
#   type = string
# }

# variable "application" {
#   type = string
# }

# variable "build_date" {
#   type = string
# }

source "amazon-ebs" "example" {
    # ami_name = "${var.application}-${var.git_branch}-${var.git_commit}-${var.build_date}"
    ami_name = "$APPLICATION/$GIT_BRANCH-$GIT_COMMIT/$BUILD_DATE"
    region = "ap-southeast-2"
    instance_type = "t3.medium"
    source_ami_filter {
        filters {
          virtualization-type = "hvm"
          name =  "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
          root-device-type = "ebs"
        }
        owners = ["099720109477"]
        most_recent = true
    }
    communicator = "ssh"
    ssh_username = "ubuntu"
    tags {
      Version = "$GIT_BRANCH-$GIT_COMMIT"
    }
}


build {
  sources = [
    "source.amazon-ebs.example"
  ]

  provisioner "shell" {
    scripts = ["install.sh"]
  }

  # provisioner "ansible-local" {
  #   playbook_file = "playbooks/main.yml"
  #   playbook_dir = "playbooks"
  #   extra_arguments = [
  #     "-e",
  #     "'ansible_python_interpreter=/usr/bin/python3'"
  #   ]
  # }

  post-processor "manifest" {
    output      = "manifest.json"
    strip_path  = true
  }

  post-processor "shell-local" {
    script = "tag-ami.sh"
  }
}
