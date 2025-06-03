resource "digitalocean_domain" "ltgk_net" {
  name = "ltgk.net"
}

resource "digitalocean_project_resources" "ltgk_net_project" {
  project = data.digitalocean_project.project.id
  resources = [
    digitalocean_domain.ltgk_net.urn,
  ]
}

# resource "digitalocean_record" "ns1" {
#   domain = digitalocean_domain.ltgk_net.name
#   type   = "NS"
#   name   = "@"
#   value  = "ns1.digitalocean.com."
#   ttl    = 1800
# }

# resource "digitalocean_record" "ns2" {
#   domain = digitalocean_domain.ltgk_net.name
#   type   = "NS"
#   name   = "@"
#   value  = "ns2.digitalocean.com."
#   ttl    = 1800
# }

# resource "digitalocean_record" "ns3" {
#   domain = digitalocean_domain.ltgk_net.name
#   type   = "NS"
#   name   = "@"
#   value  = "ns3.digitalocean.com."
#   ttl    = 1800
# }

resource "digitalocean_record" "mx1" {
  domain   = digitalocean_domain.ltgk_net.name
  type     = "MX"
  name     = "@"
  value    = "fwd1.porkbun.com."
  priority = 10
  ttl      = 600
}

resource "digitalocean_record" "mx2" {
  domain   = digitalocean_domain.ltgk_net.name
  type     = "MX"
  name     = "@"
  value    = "fwd2.porkbun.com."
  priority = 20
  ttl      = 600
}

resource "digitalocean_record" "dmarc" {
  domain = digitalocean_domain.ltgk_net.name
  type   = "TXT"
  name   = "_dmarc"
  value  = "v=DMARC1; p=quarantine; rua=mailto:25f8c5e6@mxtoolbox.dmarc-report.com; ruf=mailto:25f8c5e6@forensics.dmarc-report.com; fo=1"
  ttl    = 300
}

resource "digitalocean_record" "domainkey" {
  domain = digitalocean_domain.ltgk_net.name
  type   = "TXT"
  name   = "default._domainkey"
  value  = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC8158yxaFjZYq/gcbZ9pfsLcq7pkABLfl8q1AXWbAMpgZSUdpw1o/CKSHmVpnYL9pwLTYvLxpN9W8DkO5lSRFWxP/ljKCX/rJzSJ28MwI7UuPjbWpG43/zdIJc9yUP8F9ulmumnVinMEvQPVW49u1RPSDeCovTMWCrLXeRrRE86wIDAQAB"
  ttl    = 300
}

resource "digitalocean_record" "sfp" {
  domain = digitalocean_domain.ltgk_net.name
  type   = "TXT"
  name   = "@"
  value  = "v=spf1 include:_spf.porkbun.com ~all"
  ttl    = 300
}
