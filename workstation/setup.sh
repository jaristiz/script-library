#!/bin/bash

sudo apt-get update -y
sudo apt-get -y upgrade snapd

brew update
brew install direnv
brew install jq
brew install azure-cli
brew install terraform 

sudo snap install bw
