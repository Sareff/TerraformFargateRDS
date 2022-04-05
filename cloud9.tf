resource "aws_cloud9_environment_ec2" "cloud9-task-2" {
  instance_type = "t2.micro"
  name          = "cloud9-task-2"
}