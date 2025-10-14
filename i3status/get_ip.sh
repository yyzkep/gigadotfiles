#!/bin/sh
ip addr show enp0s26u1u1 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1
