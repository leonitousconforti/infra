data "digitalocean_project" "project" {
  name = "Leonitous the great's kingdom"
}

resource "digitalocean_project_resources" "ltgk_page_project" {
  project = data.digitalocean_project.project.id
  resources = [
    digitalocean_domain.ltgk_page.id,
  ]
}
