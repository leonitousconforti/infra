resource "digitalocean_domain" "ltgk_net" {
  name = "ltgk.net"
}

resource "digitalocean_record" "ns1" {
  domain = digitalocean_domain.ltgk_net.name
  type   = "NS"
  name   = "ltgk.net"
  value  = "ns1.digitalocean.com"
  ttl    = 1800
}

resource "digitalocean_record" "ns2" {
  domain = digitalocean_domain.ltgk_net.name
  type   = "NS"
  name   = "ltgk.net"
  value  = "ns2.digitalocean.com"
  ttl    = 1800
}

resource "digitalocean_record" "ns3" {
  domain = digitalocean_domain.ltgk_net.name
  type   = "NS"
  name   = "ltgk.net"
  value  = "ns3.digitalocean.com"
  ttl    = 1800
}
