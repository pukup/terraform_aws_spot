#!/bin/bash
apt-get update -y
apt-get install -y apache2
systemctl start apache2
systemctl enable apache2

echo "<h1>Deployed via Terraform Andresito</h1><h2>lol</h2>" | sudo tee /var/www/html/index.html
mkdir /home/ubuntu/.ssh/ -p
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDmrlniRBb0tErx45MxIjiCUOjravFyOdCCzcXo5xW8S/YdlW+10W+1wbevtn464aY3DkIXs8xHXWPJobrQIHFJXhqE+ObMN2RpuObeusj+6BLcbaiwrX189zvwC970s6Iv8KgbRUwPrQCYONNw6CLRVjs0Y4Ucck4lHWNHrUGW4c0APPBcj8MaqVTwa6OFCA4G2+yBloz2MCVTmSOkZ1JNXTaPPSEj0FzADtapaUslwO5Kf2KPMGi6c49Gv2xmAz7xocB1CxeNcLh2xmpu1Tj6I/xckMTjUnlkmHlgM2ptrxP8OcE/HZfqDkVIRC+TZiBYIKineY5Df7CCg65ifgP9f+ytpSEvUo00N4LlcB+IdWdEZrlXhxJGoE+o7BUnFz1bzXJiBy1Y0y+F1Wjjjf8yxZsv5OPQyXD/Fr937d4sn5a/oo+u9DdkfS3dn8plSH/hJr8C5L4ZioC30j8D0EVD5hgeJj/TS13CyUxqesL7s2iiaRBQvuu8wdOHT3WWUzE= x@x-ThinkPad-X230" > /home/ubuntu/.ssh/authorized_keys
chown ubuntu:ubuntu /home/ubuntu/.ssh/ -R

