resource "digitalocean_droplet" "gateway-sfo3" {
  count  = 1
  region = "sfo3"
  image  = "ubuntu-24-04-x64"
  size   = "s-1vcpu-512mb-10gb"
  name   = "gateway.sfo3.ltgk.net"

  ipv6          = true
  monitoring    = true
  droplet_agent = true
  tags          = ["gateway"]
  ssh_keys      = [data.digitalocean_ssh_key.personal.id]
  vpc_uuid      = digitalocean_vpc.vpc-ltgk-internal-sfo3.id

  depends_on = [
    time_sleep.wait-30-seconds-to-destroy-vpcs
  ]

  connection {
    timeout = "2m"
    type    = "ssh"
    user    = "root"
    agent   = true
    host    = self.ipv4_address
  }

  user_data = <<EOF
    #cloud-config
    package_update: true
    package_upgrade: true
    packages:
        - wireguard
        - iptables-persistent
    runcmd:
        - sysctl -w net.ipv4.ip_forward=1
        - echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
        - iptables -t nat -A POSTROUTING -s ${digitalocean_vpc.vpc-ltgk-internal-sfo3.ip_range} -o eth0 -j MASQUERADE
        - iptables-save > /etc/iptables/rules.v4
        - iptables-save > /etc/iptables/rules.v6
  EOF

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait  > /dev/null 2>&1",
      "[ $? -ne 0 ] && echo 'Cloud-init failed' && exit 1",
      "cloud-init clean --reboot --logs"
    ]
  }
}

resource "digitalocean_project_resources" "gateway-sfo3-project-assignment" {
  project = data.digitalocean_project.project.id
  resources = [
    digitalocean_droplet.gateway-sfo3[0].urn,
  ]
}

resource "digitalocean_reserved_ip" "gateway-sfo3-reserved-ip" {
  region     = digitalocean_droplet.gateway-sfo3[0].region
  droplet_id = digitalocean_droplet.gateway-sfo3[0].id
}

resource "digitalocean_record" "gateway-sfo3-A-record" {
  domain = digitalocean_domain.ltgk_net.name
  name   = "gateway.sfo3"
  type   = "A"
  value  = digitalocean_reserved_ip.gateway-sfo3-reserved-ip.ip_address
  ttl    = 3600
}

resource "digitalocean_record" "gateway-sfo3-AAAA-record" {
  domain = digitalocean_domain.ltgk_net.name
  name   = "gateway.sfo3"
  type   = "AAAA"
  value  = digitalocean_droplet.gateway-sfo3[0].ipv6_address
  ttl    = 3600
}
