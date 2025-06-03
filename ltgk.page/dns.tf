resource "digitalocean_domain" "ltgk_page" {
  name = "ltgk.page"
}

resource "digitalocean_record" "ns1" {
  domain = digitalocean_domain.ltgk_page.name
  type   = "NS"
  name   = "ltgk.page"
  value  = "ns1.digitalocean.com"
  ttl    = 1800
}

resource "digitalocean_record" "ns2" {
  domain = digitalocean_domain.ltgk_page.name
  type   = "NS"
  name   = "ltgk.page"
  value  = "ns2.digitalocean.com"
  ttl    = 1800
}

resource "digitalocean_record" "ns3" {
  domain = digitalocean_domain.ltgk_page.name
  type   = "NS"
  name   = "ltgk.page"
  value  = "ns3.digitalocean.com"
  ttl    = 1800
}
