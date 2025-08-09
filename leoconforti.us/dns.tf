resource "digitalocean_domain" "leoconforti_us" {
  name = "leoconforti.us"
}

resource "digitalocean_project_resources" "leoconforti_us_project" {
  project = data.digitalocean_project.project.id
  resources = [
    digitalocean_domain.leoconforti_us.urn,
  ]
}

resource "digitalocean_record" "ns1" {
  domain = digitalocean_domain.leoconforti_us.name
  type   = "NS"
  name   = "@"
  value  = "ns1.digitalocean.com."
  ttl    = 1800
}

resource "digitalocean_record" "ns2" {
  domain = digitalocean_domain.leoconforti_us.name
  type   = "NS"
  name   = "@"
  value  = "ns2.digitalocean.com."
  ttl    = 1800
}

resource "digitalocean_record" "ns3" {
  domain = digitalocean_domain.leoconforti_us.name
  type   = "NS"
  name   = "@"
  value  = "ns3.digitalocean.com."
  ttl    = 1800
}

resource "digitalocean_record" "mx1" {
  domain   = digitalocean_domain.leoconforti_us.name
  type     = "MX"
  name     = "@"
  value    = "fwd1.porkbun.com."
  priority = 10
  ttl      = 600
}

resource "digitalocean_record" "mx2" {
  domain   = digitalocean_domain.leoconforti_us.name
  type     = "MX"
  name     = "@"
  value    = "fwd2.porkbun.com."
  priority = 20
  ttl      = 600
}

resource "digitalocean_record" "dmarc" {
  domain = digitalocean_domain.leoconforti_us.name
  type   = "TXT"
  name   = "_dmarc"
  value  = "v=DMARC1; p=quarantine; rua=mailto:25f8c5e6@mxtoolbox.dmarc-report.com; ruf=mailto:25f8c5e6@forensics.dmarc-report.com; fo=1"
  ttl    = 300
}

resource "digitalocean_record" "domainkey" {
  domain = digitalocean_domain.leoconforti_us.name
  type   = "TXT"
  name   = "default._domainkey"
  value  = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDdEz47qw+QP7JOcA4BHUGtaEvscizOD4EL7OUQqtWtT06gwh6cnLw3yKA9loYMlj8VLVl23dj/3oTg+XeJABLdF+UDcJYsjW0ysD+n5EbXsXRapFf6tnHIqxkRLlXIxpuYhHja0P0Y+RTXyOqv0RdK3hH/f+vQzMkJLJDxf3kZvwIDAQAB"
  ttl    = 300
}

resource "digitalocean_record" "sfp" {
  domain = digitalocean_domain.leoconforti_us.name
  type   = "TXT"
  name   = "@"
  value  = "v=spf1 mx include:_spf.porkbun.com ~all"
  ttl    = 300
}
