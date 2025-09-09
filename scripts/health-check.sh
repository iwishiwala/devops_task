#!/bin/bash

# Health Check Script for DevOps Takehome Application
# Usage: ./scripts/health-check.sh [URL]
# Example: ./scripts/health-check.sh http://localhost:3000

set -e

# Default URL if not provided
URL=${1:-"http://localhost:3000"}

echo "🔍 Health Check Script for DevOps Takehome Application"
echo "🌐 Testing URL: $URL"
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    case $status in
        "SUCCESS")
            echo -e "${GREEN}✅ $message${NC}"
            ;;
        "ERROR")
            echo -e "${RED}❌ $message${NC}"
            ;;
        "WARNING")
            echo -e "${YELLOW}⚠️  $message${NC}"
            ;;
        "INFO")
            echo -e "${BLUE}ℹ️  $message${NC}"
            ;;
    esac
}

# Function to test endpoint
test_endpoint() {
    local endpoint=$1
    local expected_status=${2:-200}
    local description=$3
    
    echo "🔍 Testing $description..."
    
    response=$(curl -s -w "\n%{http_code}" "$URL$endpoint" || echo -e "\n000")
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n -1)
    
    if [ "$http_code" = "$expected_status" ]; then
        print_status "SUCCESS" "$description - HTTP $http_code"
        if [ -n "$body" ]; then
            echo "   Response: $body" | head -c 100
            [ ${#body} -gt 100 ] && echo "..."
        fi
        return 0
    else
        print_status "ERROR" "$description - HTTP $http_code (expected $expected_status)"
        return 1
    fi
}

# Function to test JSON response
test_json_endpoint() {
    local endpoint=$1
    local description=$2
    local json_field=$3
    local expected_value=$4
    
    echo "🔍 Testing $description..."
    
    response=$(curl -s "$URL$endpoint" || echo "{}")
    
    if command -v jq >/dev/null 2>&1; then
        if echo "$response" | jq -e . >/dev/null 2>&1; then
            actual_value=$(echo "$response" | jq -r ".$json_field" 2>/dev/null || echo "null")
            if [ "$actual_value" = "$expected_value" ]; then
                print_status "SUCCESS" "$description - $json_field: $actual_value"
                return 0
            else
                print_status "ERROR" "$description - $json_field: $actual_value (expected: $expected_value)"
                return 1
            fi
        else
            print_status "ERROR" "$description - Invalid JSON response"
            return 1
        fi
    else
        print_status "WARNING" "$description - jq not available, skipping JSON validation"
        return 0
    fi
}

# Main health check
main() {
    local exit_code=0
    
    echo "Starting health checks..."
    echo ""
    
    # Test basic connectivity
    test_endpoint "/" 200 "Basic connectivity" || exit_code=1
    
    # Test health endpoint
    test_json_endpoint "/health" "Health endpoint" "status" "healthy" || exit_code=1
    
    # Test readiness endpoint
    test_json_endpoint "/ready" "Readiness endpoint" "status" "ready" || exit_code=1
    
    # Test liveness endpoint
    test_json_endpoint "/live" "Liveness endpoint" "status" "alive" || exit_code=1
    
    # Test API endpoint
    test_endpoint "/api" 200 "API endpoint" || exit_code=1
    
    echo ""
    echo "=================================================="
    
    if [ $exit_code -eq 0 ]; then
        print_status "SUCCESS" "All health checks passed! 🎉"
        echo ""
        echo "🔗 Available endpoints:"
        echo "   • Application: $URL"
        echo "   • Health Check: $URL/health"
        echo "   • API Status: $URL/api"
        echo "   • Readiness: $URL/ready"
        echo "   • Liveness: $URL/live"
    else
        print_status "ERROR" "Some health checks failed! ❌"
        echo ""
        echo "💡 Troubleshooting tips:"
        echo "   • Check if the application is running"
        echo "   • Verify the URL is correct"
        echo "   • Check application logs for errors"
        echo "   • Ensure all dependencies are installed"
    fi
    
    exit $exit_code
}

# Run main function
main
