#!/bin/bash

# Define your variables
CHANGE_ID="21"


# Use command substitution to insert the variables into the JSON payload
PAYLOAD="{\"event_type\":\"jenkins-triggered\",\"client_payload\":{\"pr_number\":\"$CHANGE_ID\"}}"
# '{"event_type":"jenkins-triggered","client_payload":{"pr_number":"$CHANGE_ID"}}'

# Use the curl command with the payload
curl -X POST https://api.github.com/repos/ane4ka0205/terraform-lambda/dispatches \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -H "Authorization: token token" \
  -H "Accept: application/vnd.github+json" \
  -d "$PAYLOAD"
