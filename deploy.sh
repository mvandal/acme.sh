#!/bin/bash
tar -cf acme.tar config.yaml run.sh Dockerfile translations/*
scp acme.tar root@hometest.local:/addons/
