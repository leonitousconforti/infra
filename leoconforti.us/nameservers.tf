resource "porkbun_domain_nameservers" "leoconforti_us_nameservers" {
  domain = "leoconforti.us"

  nameservers = [
    "ns1.digitalocean.com",
    "ns2.digitalocean.com",
    "ns3.digitalocean.com"
  ]
}
