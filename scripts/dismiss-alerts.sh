#!/bin/bash

# Check if gh is installed and authenticated
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed"
    echo "Please install it from: https://cli.github.com/"
    exit 1
fi

# Repository details
OWNER="replicatedhq"
REPO="security-team-vulnerable-by-design"

# Get all open code scanning alerts
echo "Fetching code scanning alerts..."
alerts=$(gh api \
    repos/$OWNER/$REPO/code-scanning/alerts?state=open \
    --jq '.[].number')

# Process each alert
for alert_number in $alerts; do
    echo "Dismissing alert #$alert_number..."
    
    # Dismiss the alert
    gh api \
        --method PATCH \
        repos/$OWNER/$REPO/code-scanning/alerts/$alert_number \
        -f state=dismissed \
        -f dismissed_reason=test \
        -f dismissed_comment="Dismissed as this is a vulnerable-by-design test repository"
    
    echo "Alert #$alert_number dismissed"
    # Small delay to avoid rate limiting
    sleep 1
done

echo "All alerts have been dismissed" 