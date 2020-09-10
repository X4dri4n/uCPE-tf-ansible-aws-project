#Create Alias record towards ALB from Route53
resource "aws_route53_record" "ucpe" {
  provider = aws.ucpe
  zone_id  = aws_route53_zone.private.zone_id
  name     = join(".", ["ucpe", aws_route53_zone.private.name])
  type     = "A"
  alias {
    name                   = aws_lb.net-lb.dns_name
    zone_id                = aws_lb.net-lb.zone_id
    evaluate_target_health = true
  }
}
