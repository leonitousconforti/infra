# locals {
#   regions = {
#     sfo3 = {
#       default_vpc_name = "default-sfo3"
#     }
#     ams3 = {
#       default_vpc_name = "default-ams3"
#     }
#     sgp1 = {
#       default_vpc_name = "default-sgp1"
#     }
#   }

#   peering_combinations = {
#     for pair in flatten([
#       for i, r1_key in sort(keys(local.regions)) : [
#         for j, r2_key in sort(keys(local.regions)) : {
#           i      = i
#           j      = j
#           r1_key = r1_key
#           r2_key = r2_key
#         }
#       ]
#     ]) :
#     "${pair.r1_key}-${pair.r2_key}" => {
#       region1 = pair.r1_key
#       region2 = pair.r2_key
#       name    = "ltgk-internal-${pair.r1_key}-and-${pair.r2_key}"
#     } if pair.i < pair.j
#   }
# }

# data "digitalocean_vpc" "vpc_default" {
#   # region   = each.key
#   name     = each.value.default_vpc_name
#   for_each = local.regions
# }

# resource "digitalocean_vpc" "vpc_ltgk_internal" {
#   for_each   = local.regions
#   region     = each.key
#   name       = "ltgk-internal-${each.key}"
#   depends_on = [data.digitalocean_vpc.vpc_default]
# }

# resource "time_sleep" "wait_to_destroy_vpcs" {
#   destroy_duration = "30s"
#   depends_on       = [digitalocean_vpc.vpc_ltgk_internal]
# }

# resource "digitalocean_vpc_peering" "vpc_peering_ltgk_internal" {
#   for_each = local.peering_combinations
#   name     = each.value.name
#   vpc_ids = [
#     digitalocean_vpc.vpc_ltgk_internal[each.value.region1].id,
#     digitalocean_vpc.vpc_ltgk_internal[each.value.region2].id
#   ]
# }

# data "cloudinit_config" "gateway_cloud_init_config" {
#   for_each      = local.regions
#   gzip          = false
#   base64_encode = false

#   part {
#     filename     = "cloud.conf"
#     content_type = "text/cloud-config"
#     content = yamlencode(
#       {
#         fqdn            = "gateway.${each.key}.ltgk.net",
#         hostname        = "gateway.${each.key}.ltgk.net",
#         package_update  = true,
#         package_upgrade = true,
#         packages = [
#           "iptables-persistent",
#           "ca-certificates",
#           "curl",
#           "gnupg"
#         ],
#         runcmd = [
#           # Setup droplet as vpc gateway
#           "sysctl -w net.ipv4.ip_forward=1",
#           "echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf",
#           "iptables -t nat -A POSTROUTING -s ${digitalocean_vpc.vpc_ltgk_internal[each.key].ip_range} -o eth0 -j MASQUERADE",
#           "iptables-save > /etc/iptables/rules.v4",
#           # Setup docker
#           "install -m 0755 -d /etc/apt/keyrings",
#           "curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc",
#           "chmod a+r /etc/apt/keyrings/docker.asc",
#           "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$${UBUNTU_CODENAME:-$VERSION_CODENAME}\") stable\" | tee /etc/apt/sources.list.d/docker.list > /dev/null",
#           "apt-get update",
#           "apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
#         ]
#       }
#     )
#   }
# }

# resource "digitalocean_droplet" "gateway_droplet" {
#   for_each = local.regions
#   region   = each.key
#   image    = "ubuntu-24-04-x64"
#   size     = "s-1vcpu-512mb-10gb"
#   name     = "gateway.${each.key}.ltgk.net"

#   ipv6          = true
#   monitoring    = true
#   droplet_agent = true
#   tags          = ["gateway"]
#   ssh_keys      = [data.digitalocean_ssh_key.personal.id]
#   vpc_uuid      = digitalocean_vpc.vpc_ltgk_internal[each.key].id
#   user_data     = data.cloudinit_config.gateway_cloud_init_config[each.key].rendered

#   depends_on = [
#     time_sleep.wait_to_destroy_vpcs
#   ]

#   connection {
#     timeout = "2m"
#     type    = "ssh"
#     user    = "root"
#     agent   = true
#     host    = self.ipv4_address
#     port    = 22
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "set -e",
#       "cloud-init status --wait > /dev/null",
#       "shutdown -r now"
#     ]
#   }
# }

# resource "digitalocean_project_resources" "gateway_project_assignment" {
#   for_each = local.regions
#   project  = data.digitalocean_project.project.id
#   resources = [
#     digitalocean_droplet.gateway_droplet[each.key].urn,
#   ]
# }

# resource "digitalocean_reserved_ip" "gateway_reserved_ip" {
#   for_each   = local.regions
#   region     = each.key
#   droplet_id = digitalocean_droplet.gateway_droplet[each.key].id
# }

# resource "digitalocean_record" "gateway_A_record" {
#   for_each = local.regions
#   domain   = digitalocean_domain.ltgk_net.name
#   name     = "gateway.${each.key}"
#   type     = "A"
#   value    = digitalocean_reserved_ip.gateway_reserved_ip[each.key].ip_address
#   ttl      = 3600
# }

# resource "digitalocean_record" "gateway_AAAA_record" {
#   for_each = local.regions
#   domain   = digitalocean_domain.ltgk_net.name
#   name     = "gateway.${each.key}"
#   type     = "AAAA"
#   value    = digitalocean_droplet.gateway_droplet[each.key].ipv6_address
#   ttl      = 3600
# }
