resource "digitalocean_droplet" "gateway_ams3" {
  count  = 1
  region = "ams3"
  image  = "ubuntu-24-04-x64"
  size   = "s-1vcpu-512mb-10gb"
  name   = "gateway.ams3.ltgk.net"

  ipv6          = true
  monitoring    = true
  droplet_agent = true
  tags          = ["gateway"]
  ssh_keys      = [data.digitalocean_ssh_key.personal.id]
  vpc_uuid      = data.digitalocean_vpc.ltgk-internal-ams3.id

  connection {
    timeout = "2m"
    type    = "ssh"
    user    = "root"
    agent   = true
    host    = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "set -eu",
      "export IFS=$'\n\t'",
      "while pgrep -x apt > /dev/null; do sleep 1; done;",
      "DEBIAN_FRONTEND=noninteractive apt-get update",
      "DEBIAN_FRONTEND=noninteractive apt-get upgrade -y",
      "DEBIAN_FRONTEND=noninteractive apt-get install -y wireguard",
      "sysctl -w net.ipv4.ip_forward=1",
      "echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf",
      "iptables -t nat -A POSTROUTING -s ${data.digitalocean_vpc.ltgk-internal-ams3.ip_range} -o eth0 -j MASQUERADE",
      "DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent",
      "iptables-save > /etc/iptables/rules.v4",
      "iptables-save > /etc/iptables/rules.v6",
    ]
  }
}

resource "digitalocean_project_resources" "ltgk_net_project_ams3_gateway" {
  project = data.digitalocean_project.project.id
  resources = [
    digitalocean_droplet.gateway_ams3[0].urn,
  ]
}

resource "digitalocean_reserved_ip" "gateway_ams3_reserved_ip" {
  region     = digitalocean_droplet.gateway_ams3[0].region
  droplet_id = digitalocean_droplet.gateway_ams3[0].id
}

resource "digitalocean_record" "gateway_ams3_A_record" {
  domain = digitalocean_domain.ltgk_net.name
  name   = "gateway.ams3"
  type   = "A"
  value  = digitalocean_reserved_ip.gateway_ams3_reserved_ip.ip_address
  ttl    = 3600
}

resource "digitalocean_record" "gateway_ams3_AAAA_record" {
  domain = digitalocean_domain.ltgk_net.name
  name   = "gateway.ams3"
  type   = "AAAA"
  value  = digitalocean_droplet.gateway_ams3[0].ipv6_address
  ttl    = 3600
}
