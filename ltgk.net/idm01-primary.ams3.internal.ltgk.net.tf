data "cloudinit_config" "idm_cloud_init_config" {
  for_each      = local.regions
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    filename     = "cloud.conf"
    content = yamlencode(
      {
        fqdn     = "idm01-primary.${each.key}.internal.ltgk.net",
        hostname = "idm01-primary.${each.key}.internal.ltgk.net",
        network = {
          version = 2
          ethernets = {
            ens3 = {
              ipv6 = {
                method   = "auto"
                may_fail = true
              }
            }
          }
        }
        package_update  = true,
        package_upgrade = true,
        packages = [
          "firewalld"
        ],
      }
    )
  }
}

resource "digitalocean_droplet" "idm_droplet" {
  for_each = local.regions
  region   = each.key
  size     = "s-1vcpu-2gb"
  image    = "fedora-41-x64"
  name     = "idm01-primary.${each.key}.internal.ltgk.net"

  ipv6          = true
  monitoring    = true
  droplet_agent = true
  tags          = ["freeipa", "idm", "dns"]
  ssh_keys      = [data.digitalocean_ssh_key.personal.id]
  vpc_uuid      = digitalocean_vpc.vpc_ltgk_internal[each.key].id
  user_data     = data.cloudinit_config.gateway_cloud_init_config[each.key].rendered

  depends_on = [
    digitalocean_droplet.gateway_droplet,
    time_sleep.wait_to_destroy_vpcs
  ]

  connection {
    timeout = "2m"
    type    = "ssh"
    agent   = true
    user    = "root"
    host    = self.ipv4_address
    port    = 22
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "cloud-init status --wait > /dev/null",
      "ORIGINAL_PUBLIC_GATEWAY_IP=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/gateway)",
      "ip route add 169.254.169.254 via $ORIGINAL_PUBLIC_GATEWAY_IP dev eth0",
      "sed -i '/^route1=0.0.0.0\\/0,[0-9.]\\+/s/^/# /' /etc/NetworkManager/system-connections/cloud-init-ens3.nmconnection",
      "echo 'route1=0.0.0.0/0,${digitalocean_droplet.gateway_droplet[each.key].ipv4_address_private}' >> /etc/NetworkManager/system-connections/cloud-init-ens4.nmconnection",
      "shutdown -r now"
    ]
  }
}

resource "digitalocean_project_resources" "idm_project_assignment" {
  for_each = local.regions
  project  = data.digitalocean_project.project.id
  resources = [
    digitalocean_droplet.idm_droplet[each.key].urn,
  ]
}
