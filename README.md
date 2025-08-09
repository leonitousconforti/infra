# Infra

The infrastructure that powers ltgk.net

## Notes for self

```
terraform init -backend-config="../backend.tfvars"
```
then
```
terraform apply -config="../digitalocean.tfvars" -config="../porkbun.tfvars"
```
