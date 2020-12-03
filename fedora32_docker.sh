## Fedora 32 install docker, docker-compose and run odoo
## Alberto Larraz Dalmases - November 2020
docker system prune -a
docker system volume prune
sudo dnf autoremove docker

# change cgroup to compatibility with docker
sudo grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"
#sudo reboot

#cgroups
sudo mkdir /sys/fs/cgroup/systemd
sudo mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd

# change backend for firewalld to "old" iptables
#sudo sed -i 's/FirewallBackend=nftables/FirewallBackend=iptables/g' /etc/firewalld/firewalld.conf
#sudo systemctl restart firewalld

# install docker from docker repo, docker-ce stable
sudo rpmkeys --import https://download.docker.com/linux/fedora/gpg
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install --enablerepo=docker-ce-stable docker-ce-cli docker-ce -y

#enable and start docker service, check status running
sudo usermod -aG docker isard
sudo systemctl enable --now  docker
sudo systemctl status docker --no-pager

#config firewall to accept out/in connections
sudo firewall-cmd --zone=trusted --add-interface=docker0 --permanent
sudo firewall-cmd --zone=FedoraWorkstation --add-masquerade --permanent
sudo firewall-cmd --zone=public --add-masquerade --permanent
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --zone=public --add-port=443/tcp --permanent
sudo firewall-cmd --reload

#In case Firewall fails just disable permantly

#sudo systemctl disable firewalld


#install docker compose with pip
sudo pip install docker-compose
sudo dnf -y install firefox
sudo systemctl restart docker
sudo groupadd docker
sudo usermod -aG docker $USER
sudo reboot

