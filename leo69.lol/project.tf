data "digitalocean_project" "project" {
  name = "Leonitous the great's kingdom"
}

resource "digitalocean_project_resources" "leo69_lol_project" {
  project = data.digitalocean_project.project.id
  resources = [
    digitalocean_domain.leo69_lol.id,
  ]
}
