init:
	terraform init

plan:
	terraform plan -out plan.out

apply:
	terraform apply plan.out

destroy:
	terraform destroy

list:
	terraform state list
