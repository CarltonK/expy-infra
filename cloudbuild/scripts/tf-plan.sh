if [ -d "environments/$1/" ]; then
    cd environments/$1
    terraform plan
else
    for dir in environments/*/
        do 
            cd ${dir}   
            env=${dir%*/}
            env=${env#*/}  
            echo ""
            echo "*************** TERRAFORM PLAN ******************"
            echo "******* Environment: ${env} ********"
            echo "*************************************************"
            terraform plan || exit 1
            cd ../../
        done
fi