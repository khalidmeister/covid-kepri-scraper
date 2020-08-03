#!/bin/bash

# cd ~/projects/covid-kepri-scraper && /usr/bin/python kepri-scraper.py >> overall.out

sleep 5

cd ~/projects/covid-kepri-scraper && /usr/bin/git add .
cd ~/projects/covid-kepri-scraper && /usr/bin/git commit -m "Update Dataset"
HOME = /home/pi/.ssh/id_rsa
/usr/bin/git push origin master
