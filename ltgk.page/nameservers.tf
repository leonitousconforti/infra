resource "porkbun_domain_nameservers" "ltgk_page_nameservers" {
  domain = "ltgk.page"

  nameservers = [
    "ns1.digitalocean.com",
    "ns2.digitalocean.com",
    "ns3.digitalocean.com"
  ]
}
