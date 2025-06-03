data "cloudinit_config" "gateway-sgp1-cloud-init-config" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    filename     = "cloud.conf"
    content = yamlencode(
      {
        package_update  = true,
        package_upgrade = true,
        packages = [
          "wireguard",
          "iptables-persistent"
        ],
        runcmd = [
          "sysctl -w net.ipv4.ip_forward=1",
          "echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf",
          "iptables -t nat -A POSTROUTING -s ${digitalocean_vpc.vpc-ltgk-internal-sgp1.ip_range} -o eth0 -j MASQUERADE",
          "iptables-save > /etc/iptables/rules.v4"
        ]
      }
    )
  }
}

resource "digitalocean_droplet" "gateway-sgp1" {
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
  vpc_uuid      = digitalocean_vpc.vpc-ltgk-internal-sgp1.id
  user_data     = data.cloudinit_config.gateway-sgp1-cloud-init-config.rendered

  depends_on = [
    time_sleep.wait-30-seconds-to-destroy-vpcs
  ]

  connection {
    timeout = "2m"
    type    = "ssh"
    user    = "root"
    agent   = true
    host    = self.ipv4_address
    port    = 22
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "cloud-init status --wait > /dev/null",
      "shutdown -r now"
    ]
  }
}

resource "digitalocean_project_resources" "gateway-sgp1-project-assignment" {
  project = data.digitalocean_project.project.id
  resources = [
    digitalocean_droplet.gateway-sgp1[0].urn,
  ]
}

resource "digitalocean_reserved_ip" "gateway-sgp1-reserved-ip" {
  region     = digitalocean_droplet.gateway-sgp1[0].region
  droplet_id = digitalocean_droplet.gateway-sgp1[0].id
}

resource "digitalocean_record" "gateway-sgp1-A-record" {
  domain = digitalocean_domain.ltgk_net.name
  name   = "gateway.sgp1"
  type   = "A"
  value  = digitalocean_reserved_ip.gateway-sgp1-reserved-ip.ip_address
  ttl    = 3600
}

resource "digitalocean_record" "gateway-sgp1-AAAA-record" {
  domain = digitalocean_domain.ltgk_net.name
  name   = "gateway.sgp1"
  type   = "AAAA"
  value  = digitalocean_droplet.gateway-sgp1[0].ipv6_address
  ttl    = 3600
}
