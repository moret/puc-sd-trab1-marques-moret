#!/bin/sh

# Create files

dd if=/dev/zero of=10KB.txt bs=1k count=10
dd if=/dev/zero of=100KB.txt bs=1k count=100
dd if=/dev/zero of=1MB.txt bs=1M count=1
dd if=/dev/zero of=10MB.txt bs=1M count=10
dd if=/dev/zero of=100MB.txt bs=1M count=100
