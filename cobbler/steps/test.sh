#!/bin/bash
    
echo "code-oss header: [$(file -h .code/.build/electron/code-oss)]";
    
echo "Running tests";
./scripts/test.sh;

echo "Running integration tests";
./scripts/test-integration.sh;
