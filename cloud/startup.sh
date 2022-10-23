sudo apt update
sudo apt-get install -y docker.io
sudo service docker start
echo "{\"ipv6\": true,\"fixed-cidr-v6\": \"fd00::/80\"}" | sudo tee /etc/docker/daemon.json
sudo usermod -a -G docker ubuntu
sudo gpasswd -a ubuntu docker
sudo ip6tables -t nat -A POSTROUTING -s fd00::/80 ! -o docker0 -j MASQUERADE
sudo service docker restart