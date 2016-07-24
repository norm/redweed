resource "aws_route53_zone" "normpress" {
    name = "normpress.com"
}

resource "aws_s3_bucket" "normpress_bucket" {
    bucket = "normpress.com"

    website = {
        redirect_all_requests_to = "https://github.com/norm/flourish"
    }
}

resource "aws_route53_record" "apex_normpress" {
    name = "normpress.com"
    type = "A"

    alias {
        name = "${aws_s3_bucket.normpress_bucket.website_domain}"
        zone_id = "${aws_s3_bucket.normpress_bucket.hosted_zone_id}"
        evaluate_target_health = false
    }

    zone_id = "${aws_route53_zone.normpress.zone_id}"
}
