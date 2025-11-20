
resource "aws_instance" "webserver1" {
  ami           = "ami-0ecb62995f68bb549"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet.id
  tags = {
    Name = "Webserver1"
  }
  key_name = data.aws_key_pair.example.key_name
  associate_public_ip_address = true
  user_data = file("usedata.sh")


}


data "aws_subnet" "public_subnet" {
  id = "subnet-0f757a14a4fc12318"
}



data "aws_key_pair" "example" {
  key_name           = "my-key-pair"
  include_public_key = true

}