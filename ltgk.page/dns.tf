resource "digitalocean_domain" "ltgk_page" {
  name = "ltgk.page"
}

resource "digitalocean_project_resources" "ltgk_page_project" {
  project = data.digitalocean_project.project.id
  resources = [
    digitalocean_domain.ltgk_page.urn,
  ]
}

# resource "digitalocean_record" "ns1" {
#   domain = digitalocean_domain.ltgk_page.name
#   type   = "NS"
#   name   = "@"
#   value  = "ns1.digitalocean.com."
#   ttl    = 1800
# }

# resource "digitalocean_record" "ns2" {
#   domain = digitalocean_domain.ltgk_page.name
#   type   = "NS"
#   name   = "@"
#   value  = "ns2.digitalocean.com."
#   ttl    = 1800
# }

# resource "digitalocean_record" "ns3" {
#   domain = digitalocean_domain.ltgk_page.name
#   type   = "NS"
#   name   = "@"
#   value  = "ns3.digitalocean.com."
#   ttl    = 1800
# }
