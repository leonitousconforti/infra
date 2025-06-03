resource "porkbun_domain_nameservers" "ltgk_net_nameservers" {
  domain = "ltgk.net"

  nameservers = [
    "ns1.digitalocean.com",
    "ns2.digitalocean.com",
    "ns3.digitalocean.com"
  ]
}
