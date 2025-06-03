resource "digitalocean_domain" "leo69_lol" {
  name = "leo69.lol"
}

resource "digitalocean_record" "ns1" {
  domain = digitalocean_domain.leo69_lol.name
  type   = "NS"
  name   = "leo69.lol"
  value  = "ns1.digitalocean.com"
  ttl    = 1800
}

resource "digitalocean_record" "ns2" {
  domain = digitalocean_domain.leo69_lol.name
  type   = "NS"
  name   = "leo69.lol"
  value  = "ns2.digitalocean.com"
  ttl    = 1800
}

resource "digitalocean_record" "ns3" {
  domain = digitalocean_domain.leo69_lol.name
  type   = "NS"
  name   = "leo69.lol"
  value  = "ns3.digitalocean.com"
  ttl    = 1800
}
