# keys to the kingdom
variable "aws_access_key" {
    default = "FILL ME OUT"
}
variable "aws_secret_key" {
    default = "FILL ME OUT"
}

# where to do stuff
variable "aws_region" {
    default = "eu-west-1"
}
variable "aws_availability_zone" {
    default = "eu-west-1a"
}

# certificates
variable "withaflourish_arn" {
    # the certificate ARN looks something like this:
    default = "arn:aws:acm:REGION:ID:certificate/CERTIFICATE_ID"
}
