resource "digitalocean_droplet" "gateway_sgp1" {
  count  = 1
  region = "sgp1"
  image  = "ubuntu-24-04-x64"
  size   = "s-1vcpu-512mb-10gb"
  name   = "gateway.sgp1.ltgk.net"

  ipv6          = true
  monitoring    = true
  droplet_agent = true
  tags          = ["gateway"]
  ssh_keys      = [data.digitalocean_ssh_key.personal.id]
  vpc_uuid      = data.digitalocean_vpc.ltgk-internal-sgp1.id
}

resource "digitalocean_project_resources" "ltgk_net_project_sgp1_gateway" {
  project = data.digitalocean_project.project.id
  resources = [
    digitalocean_droplet.gateway_sgp1[0].urn,
  ]
}

resource "digitalocean_reserved_ip" "gateway_sgp1_reserved_ip" {
  region     = digitalocean_droplet.gateway_sgp1[0].region
  droplet_id = digitalocean_droplet.gateway_sgp1[0].id
}

resource "digitalocean_record" "gateway_sgp1_A_record" {
  domain = digitalocean_domain.ltgk_net.name
  name   = "gateway.sgp1"
  type   = "A"
  value  = digitalocean_reserved_ip.gateway_sgp1_reserved_ip.ip_address
  ttl    = 3600
}

resource "digitalocean_record" "gateway_sgp1_AAAA_record" {
  domain = digitalocean_domain.ltgk_net.name
  name   = "gateway.sgp1"
  type   = "AAAA"
  value  = digitalocean_droplet.gateway_sgp1[0].ipv6_address
  ttl    = 3600
}
