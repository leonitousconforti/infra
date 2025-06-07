# data "cloudinit_config" "idm01-primary-ams3-cloud-init-config" {
#   gzip          = false
#   base64_encode = false

#   part {
#     content_type = "text/cloud-config"
#     filename     = "cloud.conf"
#     content = yamlencode(
#       {
#         package_update  = true,
#         package_upgrade = true,
#         packages = [
#           "firewalld"
#         ],
#         runcmd = [
#           "ORIGINAL_PUBLIC_GATEWAY_IP=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/gateway)",
#           "ip route add 169.254.169.254 via $ORIGINAL_PUBLIC_GATEWAY_IP dev eth0",

#           # Delete or comment out this route from the /etc/NetworkManager/system-connections/cloud-init-eth0.nmconnection file.
#           # route1=0.0.0.0/0,<default_gateway_IP_address>
#             "sed -i '/^route1=0.0.0.0\\/0,/d' /etc/NetworkManager/system-connections/cloud-init-eth0.nmconnection",
#         ]
#       }
#     )
#   }
# }

# resource "digitalocean_droplet" "idm01-primary-ams3" {
#   count  = 1
#   region = "ams3"
#   size   = "s-1vcpu-2gb"
#   image  = "fedora-41-x64"
#   name   = "idm01-primary.ams3.internal.ltgk.net"

#   ipv6          = true
#   monitoring    = true
#   droplet_agent = true
#   tags          = ["freeipa", "idm", "dns"]
#   ssh_keys      = [data.digitalocean_ssh_key.personal.id]
#   vpc_uuid      = digitalocean_vpc.vpc-ltgk-internal-ams3.id
#   user_data     = data.cloudinit_config.idm01-primary-ams3-cloud-init-config.rendered

#   depends_on = [
#     digitalocean_droplet.gateway-ams3,
#     time_sleep.wait-30-seconds-to-destroy-vpcs
#   ]

#   connection {
#     timeout = "2m"
#     type    = "ssh"
#     agent   = true
#     user    = "root"
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

# resource "digitalocean_project_resources" "idm01-primary-ams3-project-assignment" {
#   project = data.digitalocean_project.project.id
#   resources = [
#     digitalocean_droplet.idm01-primary-ams3[0].urn,
#   ]
# }
