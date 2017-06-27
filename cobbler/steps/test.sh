#!/bin/bash
set -e;
    
echo "Running tests";
./scripts/test.sh;

echo "Running integration tests";
./scripts/test-integration.sh;
