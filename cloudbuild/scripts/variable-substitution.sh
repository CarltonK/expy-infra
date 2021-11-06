echo "***********************"
echo "You're currently on $1 branch"
echo "***********************"

echo "***********************"
echo "Variable substitution"
echo "***********************"

awk '{gsub(/<EXPY_PROJECT_ID>/,"'$2'")}1' /workspace/environments/develop/backend.tf > /workspace/tmp.tf && mv /workspace/tmp.tf /workspace/environments/develop/backend.tf
awk '{gsub(/<EXPY_PROJECT_ID>/,"'$2'")}1' /workspace/environments/develop/terraform.tfvars > /workspace/tmp.tfvars && mv /workspace/tmp.tfvars /workspace/environments/develop/terraform.tfvars
awk '{gsub(/<DATABASE_USER>/,"'$3'")}1' /workspace/environments/develop/terraform.tfvars > /workspace/tmp.tfvars && mv /workspace/tmp.tfvars /workspace/environments/develop/terraform.tfvars
awk '{gsub(/<DATABASE_PASSWORD>/,"'$4'")}1' /workspace/environments/develop/terraform.tfvars > /workspace/tmp.tfvars && mv /workspace/tmp.tfvars /workspace/environments/develop/terraform.tfvars