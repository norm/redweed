resource "aws_route53_zone" "basecss" {
    name = "basecss.com"
}

resource "aws_s3_bucket" "basecss_bucket" {
    bucket = "basecss.com"
    acl = "public-read"
    policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Sid": "PublicReadForGetBucketObjects",
        "Effect": "Allow",
        "Principal": "*",
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::basecss.com/*"
    }]
}
POLICY

    website = {
        index_document = "index.html"
        error_document = "404.html"
    }
}

resource "aws_route53_record" "apex_basecss" {
    name = "basecss.com"
    type = "A"

    alias {
        name = "${aws_s3_bucket.basecss_bucket.website_domain}"
        zone_id = "${aws_s3_bucket.basecss_bucket.hosted_zone_id}"
        evaluate_target_health = false
    }

    zone_id = "${aws_route53_zone.basecss.zone_id}"
}
