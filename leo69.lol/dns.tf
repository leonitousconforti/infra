resource "digitalocean_domain" "leo69_lol" {
  name = "leo69.lol"
}

resource "digitalocean_project_resources" "leo69_lol_project" {
  project = data.digitalocean_project.project.id
  resources = [
    digitalocean_domain.leo69_lol.urn,
  ]
}

resource "digitalocean_record" "ns1" {
  domain = digitalocean_domain.leo69_lol.name
  type   = "NS"
  name   = "leo69.lol"
  value  = "ns1.digitalocean.com."
  ttl    = 1800
}

resource "digitalocean_record" "ns2" {
  domain = digitalocean_domain.leo69_lol.name
  type   = "NS"
  name   = "leo69.lol"
  value  = "ns2.digitalocean.com."
  ttl    = 1800
}

resource "digitalocean_record" "ns3" {
  domain = digitalocean_domain.leo69_lol.name
  type   = "NS"
  name   = "leo69.lol"
  value  = "ns3.digitalocean.com."
  ttl    = 1800
}
