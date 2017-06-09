#!/bin/bash

echo "Starting xvfb";
sh -e /etc/init.d/xvfb start;

echo "Waiting 10 seconds for xvfb to start up";
sleep 10;
