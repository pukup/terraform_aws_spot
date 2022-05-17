init:
	terraform init

plan:
	terraform init
	terraform plan

apply:
	terraform apply

destroy:
	terraform destroy

list:
	terraform state list
