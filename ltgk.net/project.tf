data "digitalocean_project" "project" {
  name = "Leonitous the great's kingdom"
}

data "digitalocean_ssh_key" "personal" {
  name = "ed25519 leoconforti@ltgk.net"
  #   fingerprint = "0c:b0:d8:3c:11:c7:87:2e:60:e1:bc:2d:64:71:84:06"
}
