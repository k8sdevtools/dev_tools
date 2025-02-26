#!/bin/bash

# Define the AWS account and environment mappings
declare -A aws_account
aws_account["ccbt-dev"]="123,stuff"
aws_account["ccbt-non-prod"]="123,morestuff"
aws_account["ccbt-prod"]="456,otherstuff"
aws_account["invest-dev"]="123,investstuff"
aws_account["invest-non-prod"]="123,moreinveststuff"
aws_account["invest-prod"]="456,otherinveststuff"

# Function to display matching key-value pairs and run terraform commands
display_matching_pairs() {
    local input_aws_account=$1
    local input_aws_environment=$2

    for key in "${!aws_account[@]}"; do
        # Split the key into environment and account
        local env="${key%%-*}"   # Extract the environment part (e.g., "ccbt")
        local acc="${key#*-}"    # Extract the account part (e.g., "dev")

        # Match specific account and environment or wildcard "all" scenarios
        if { [[ "$input_aws_environment" == "all" ]] || [[ "$input_aws_environment" == "$acc" ]]; } &&
           { [[ "$input_aws_account" == "all" ]] || [[ "$input_aws_account" == "$env" ]]; }; then
            
            IFS=',' read -r account_id extra_info <<< "${aws_account[$key]}"
            
            echo "For key '$key':"
            echo "Account ID: $account_id"
            echo "Extra Info: $extra_info"
            echo ""
        fi
    done
}

# Example function for demonstration purposes
cleanup_resources() {
    echo "Cleanup function called with arguments: $@"
}

# Invoke the function directly based on CLI arguments
function_name=$1
shift
"$function_name" "$@"
