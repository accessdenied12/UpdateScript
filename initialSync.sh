#!/bin/bash
#
#Downloads all the packages from a repo and creates one locally available by HTTP
#


packages=(rsync httpd policycoreutils-python firewalld)


if [[ ! -d /repos ]]; then
	mkdir -p /repos/CentOS/7/3
fi

function isinstalled {
	if yum list installed "$@" >/dev/null 2>&1; then
		true
	     else
		false
	fi
}

for package in ${packages[@]}; do
	if isinstalled $package; then
		echo "$package installed"
	else
		yum install -y $package >/dev/null 2>&1 
	fi
done

semanage fcontext -a -t httpd_sys_content_t "/repos(/.*)?"

restorecon -Rv /repos

cp ./repoconfig.conf /etc/httpd/conf.d

rsync -az --progress rsync://mirror.atlantic.net/centos/7.3.1611/updates/x86_64/ /repos/CentOS/7/3


systemctl enable firewalld
systemctl start firewalld
systemctl enable httpd
systemctl start firewalld
firewall-cmd --permanent --add-service={http,https}
firewall-cmd --reload




