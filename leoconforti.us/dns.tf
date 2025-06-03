resource "digitalocean_domain" "leoconforti_us" {
  name = "leoconforti.us"
}

resource "digitalocean_record" "ns1" {
  domain = digitalocean_domain.leoconforti_us.name
  type   = "NS"
  name   = "leoconforti.us"
  value  = "ns1.digitalocean.com"
  ttl    = 1800
}

resource "digitalocean_record" "ns2" {
  domain = digitalocean_domain.leoconforti_us.name
  type   = "NS"
  name   = "leoconforti.us"
  value  = "ns2.digitalocean.com"
  ttl    = 1800
}

resource "digitalocean_record" "ns3" {
  domain = digitalocean_domain.leoconforti_us.name
  type   = "NS"
  name   = "leoconforti.us"
  value  = "ns3.digitalocean.com"
  ttl    = 1800
}
