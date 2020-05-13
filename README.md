# Docker System Update
Steps to reproduce and update a docker host for testing purposes.


## Preparation

 * Install Ubuntu Server 18.10

If the version isn't supported any longer, replace repository source from `http://archive.ubuntu.com/ubuntu` to `http://old-releases.ubuntu.com/ubuntu` ([source](https://superuser.com/questions/1527250/apt-update-error-with-ubuntu-18-10-cosmic-version)).

 * Create self-signed SSL and store it in `/etc/ssl/certs_path`

```shell
$ sudo mkdir -p /etc/ssl/certs_path/
$ sudo openssl genpkey -algorithm rsa -pkeyopt rsa_keygen_bits:2048 -out /etc/ssl/certs_path/my_cert.key
$ sudo openssl req -x509 -key /etc/ssl/certs_path/my_cert.key -out /etc/ssl/certs_path/my_cert.crt -days 720 -addext "subjectAltName = DNS:breweryda.com,DNS:*.breweryda.com,IP:192.168.56.106"
```

 * Clone this repository

```bash
$ git clone https://github.com/nu12/docker_system_update.git
```

 * Run scripts 0-6 (0_purge_docker must be skiped on first iteration)

```shell
$ ./0_purge_docker && \
> ./1_install_dependencies && \
> ./2_install_docker && \
> ./3_create_docker_environment && \
> ./4_create_docker_containers && \
> ./5_create_content && \
> ./6_docker_update
```
 * Interact with applications using ports 9000-9004

## Updating the system

Since 18.10 is no longer supported, the system can only be downgraded to 18.04 before updating to 20.04.

 * Stop all containers

 * Backup Gitlab data

```shell
$ mkdir backup
$ sudo cp -r /var/lib/docker/volumes/gitlab_data backup/gitlab_data
$ sudo cp -r /var/lib/docker/volumes/gitlab_logs backup/gitlab_logs
$ sudo cp -r /var/lib/docker/volumes/gitlab_config backup/gitlab_config
```

 * Update source list (replace cosmic with bionic info)
```shell
$ sudo sed -i 's/cosmic/bionic/g' /etc/apt/sources.list
$ sudo sed -i 's/old-releases/archive/g' /etc/apt/sources.list
```

 * Pin packages

Write the following to `/etc/apt/preferences`
```
Package: *
Pin: release a=bionic
Pin-Priority: 1001
```

 * Downgrade
```shell
$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo apt-get dist-upgrade
$ cat /etc/os-release
```

Updated to Docker version 19.03.8. GitLab gets unhealthy. Restarting the container solves the issue.

All files in other containers were preserved.

 * Update

Change `prompt=lts` in `/etc/update-manager/release-upgrades` if needed.

```shell
$ sudo rm /etc/apt/preferences
$ sudo apt-get install update-manager-core
$ sudo apt-get install --reinstall ubuntu-keyring
$ do-release-upgrade [-d]
```

Use `-d` if upgrading before the first patch release (July).

 * Update docker-compose

```shell
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```

 * Update docker containers (script 7)

```shell
$ ./7_update_docker_containers
```

 * Start all containers

All containers are working.

 * Cleaning
```shell
$ sudo apt-get autoremove
$ docker system prune -a [--force]
```

 * Hold Docker packages (optional)

Prevent Docker from being upgraded. 

Add hold

```shell
$ sudo apt-mark hold docker-ce docker-ce-cli
```

Remove hold

```shell
$ sudo apt-mark unhold docker-ce docker-ce-cli
```

Show packages on hold

```shell
$ sudo apt-mark showhold
```
