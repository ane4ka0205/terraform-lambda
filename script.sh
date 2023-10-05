#!/bin/bash

# Define your variables
NAME="TEST_VAR2"
VALUE="octocat2"

# Use command substitution to insert the variables into the JSON payload
PAYLOAD="{\"name\":\"$NAME\",\"value\":\"$VALUE\"}"

# Use the curl command with the payload
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer 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" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/ane4ka0205/terraform-lambda/actions/variables \
  -d "$PAYLOAD"
