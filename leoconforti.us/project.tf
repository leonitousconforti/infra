data "digitalocean_project" "project" {
  name = "Leonitous the great's kingdom"
}

resource "digitalocean_project_resources" "leoconforti_us_project" {
  project = data.digitalocean_project.project.id
  resources = [
    digitalocean_domain.leoconforti_us.id,
  ]
}
