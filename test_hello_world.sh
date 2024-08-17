#!/bin/bash

# test_hello_world.sh
OUTPUT=$(./hello_world)

if [ "$OUTPUT" == "Hello, World!" ]; then
    echo "Test passed!"
    exit 0
else
    echo "Test failed!"
    exit 1
fi

