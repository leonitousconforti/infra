resource "porkbun_domain_nameservers" "leo69_lol_nameservers" {
  domain = "leo69.lol"

  nameservers = [
    "ns1.digitalocean.com",
    "ns2.digitalocean.com",
    "ns3.digitalocean.com"
  ]
}
