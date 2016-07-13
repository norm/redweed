resource "aws_s3_bucket" "flourish_bucket" {
    bucket = "withaflourish.net"
    acl = "public-read"
    policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Sid": "PublicReadForGetBucketObjects",
        "Effect": "Allow",
        "Principal": "*",
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::withaflourish.net/*"
    }]
}
POLICY

    website = {
        index_document = "index.html"
        error_document = "404.html"
    }
}

resource "aws_route53_zone" "flourish" {
    name = "withaflourish.net"
}

resource "aws_route53_record" "apex-flourish" {
    name = "withaflourish.net"
    type = "A"

    alias {
        name = "${aws_s3_bucket.flourish_bucket.website_domain}"
        zone_id = "${aws_s3_bucket.flourish_bucket.hosted_zone_id}"
        evaluate_target_health = false
    }

    zone_id = "${aws_route53_zone.flourish.zone_id}"
}
