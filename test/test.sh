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
        local env="${key%%-*}"
        local acc="${key#*-}"

        # If the environment is "all", match all environments for the given account prefix
        if [[ "$input_aws_environment" == "all" ]] || [[ "$input_aws_environment" == "$env" ]]; then
            if [[ "$input_aws_account" == "$acc" ]] || [[ "$input_aws_account" == "${key%%-*}" ]]; then
                IFS=',' read -r account_id extra_info <<< "${aws_account[$key]}"
                
                echo "For key '$key':"
                echo "Account ID: $account_id"
                echo "Extra Info: $extra_info"
                echo ""
            fi
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
