if [ -d "environments/$1/" ]; then
    cd environments/$1      
    terraform destroy -auto-approve
else
    echo "***************************** SKIPPING APPLYING *******************************"
    echo "Branch '$1' does not represent an official environment."
    echo "*******************************************************************************"
fi