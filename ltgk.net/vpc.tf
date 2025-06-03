data "digitalocean_vpc" "vpc-default-sfo3" {
  default = true
  region  = "sfo3"
  name    = "default-sfo3"
}

data "digitalocean_vpc" "vpc-default-ams3" {
  default = true
  region  = "ams3"
  name    = "default-ams3"
}

data "digitalocean_vpc" "vpc-default-sgp1" {
  default = true
  region  = "sgp1"
  name    = "default-sgp1"
}

resource "digitalocean_vpc" "vpc-ltgk-internal-sfo3" {
  region     = "sfo3"
  name       = "ltgk-internal-sfo3"
  depends_on = [digitalocean_vpc.vpc-default-sfo3]
}

resource "digitalocean_vpc" "vpc-ltgk-internal-ams3" {
  region     = "ams3"
  name       = "ltgk-internal-ams3"
  depends_on = [digitalocean_vpc.vpc-default-ams3]
}

resource "digitalocean_vpc" "vpc-ltgk-internal-sgp1" {
  region     = "sgp1"
  name       = "ltgk-internal-sgp1"
  depends_on = [digitalocean_vpc.vpc-default-sgp1]
}

resource "digitalocean_vpc_peering" "vpc-peering-ltgk-internal-sfo3-and-ams3" {
  name = "ltgk-internal-sfo3-and-ams3"
  vpc_ids = [
    digitalocean_vpc.ltgk-internal-sfo3.id,
    digitalocean_vpc.ltgk-internal-ams3.id
  ]
}

resource "digitalocean_vpc_peering" "vpc-peering-ltgk-internal-ams3-and-sgp1" {
  name = "ltgk-internal-ams3-and-sgp1"
  vpc_ids = [
    digitalocean_vpc.ltgk-internal-ams3.id,
    digitalocean_vpc.ltgk-internal-sgp1.id
  ]
}

resource "digitalocean_vpc_peering" "vpc-peering-ltgk-internal-sgp1-and-sfo3" {
  name = "ltgk-internal-sgp1-and-sfo3"
  vpc_ids = [
    digitalocean_vpc.ltgk-internal-sgp1.id,
    digitalocean_vpc.ltgk-internal-sfo3.id
  ]
}
