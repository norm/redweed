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
        name = "${aws_cloudfront_distribution.flourish_cloudfront.domain_name}"
        zone_id = "Z2FDTNDATAQYW2"
        evaluate_target_health = false
    }

    zone_id = "${aws_route53_zone.flourish.zone_id}"
}

resource "aws_route53_record" "slack-flourish" {
    name = "slack"
    type = "CNAME"
    ttl = "3600"
    records = ["slack-withaflourish-net.herokuapp.com"]
    zone_id = "${aws_route53_zone.flourish.zone_id}"
}

resource "aws_cloudfront_distribution" "flourish_cloudfront" {
    aliases = ["withaflourish.net"]
    default_root_object = "index.html"
    enabled = true

    origin {
        domain_name = "withaflourish.net.s3-website-eu-west-1.amazonaws.com"
        origin_id = "withaflourish_origin"
        custom_origin_config {
            http_port = 80
            https_port = 443
            origin_protocol_policy = "http-only"
            origin_ssl_protocols = ["TLSv1"]
        }
    }

    default_cache_behavior {
        target_origin_id = "withaflourish_origin"

        allowed_methods = [ "DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT" ]
        cached_methods = [ "GET", "HEAD" ]
        default_ttl = 3600
        min_ttl = 0
        max_ttl = 86400
        viewer_protocol_policy = "redirect-to-https"

        forwarded_values {
            query_string = true

            cookies {
                forward = "none"
            }
        }
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    viewer_certificate {
        acm_certificate_arn = "${var.withaflourish_arn}"
        ssl_support_method = "sni-only"
        minimum_protocol_version = "TLSv1"
    }
}
