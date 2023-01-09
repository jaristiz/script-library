#!/bin/bash

if az account show &> /dev/null; then
    echo "azure CLI is authenticated, Skipping login "
else 
    echo "azure CLI is not authenticated, logging in"
    az login >> /dev/null
fi

echo "We found the following subscriptions in your account"

az account list | jq '.[].id' -r

echo Please select the subscription to use

read -p "Subscription id:" subscription

az account set --subscription "${subscription}"

echo ""
read -p "Specify a name for the new service account provider: " sp_name

echo "Creating service principal to use with terraform "
role_variables=(`az ad sp create-for-rbac --display-name="${sp_name}" --role="Contributor" --scopes="/subscriptions/${subscription}" | jq -r '.|.appId, .displayName, .password, .tenant'`)
# role_variables=(`cat $(dirname -- $0)/test_output | jq -r '.|.appId, .displayName, .password, .tenant'`)

echo "Service principal ${role_variables[1]} created"

echo "export ARM_CLIENT_ID=${role_variables[0]}" 
echo "export ARM_SUBSCRIPTION_ID=${subscription}" 
echo "export ARM_CLIENT_SECRET=${role_variables[2]}" 
echo "export ARM_TENANT_ID=${role_variables[3]}" 
