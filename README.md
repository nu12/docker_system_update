# Docker System Update
Steps to reproduce and update a docker host for testing purposes.


## Preparation

 * Install Ubuntu Server 18.10

If the version isn't supported any longer, replace repository source from `http://archive.ubuntu.com/ubuntu` to `http://old-releases.ubuntu.com/ubuntu` ([source](https://superuser.com/questions/1527250/apt-update-error-with-ubuntu-18-10-cosmic-version)).

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

 * Update source list (replace cosmic with bionic info)
```shell
$ sudo sed -i 's/cosmic/bionic/g' /etc/apt/sources.list
$ sudo sed -i 's/old-releases/archive/g' /etc/apt/sources.list
```

 * Pin packages
```shell
$ sudo echo -e "Package: * \n \
> Pin: release a=bionic \n \
> Pin-Priority: 1001" >> /etc/apt/preferences
```

 * Downgrade
```shell
$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo apt-get install libnet-dns-sec-perl
$ sudo apt-get dist-upgrade
$ cat /etc/os-release
```

Updated to Docker version 19.03.8. GitLab got unhealthy, however restarting the container solved the issue.

All files in other containers were preserved.

 * Update
```shell
$ rm /etc/apt/preferences
$ sudo apt-get install update-manager-core
$ sudo apt-get install --reinstall ubuntu-keyring
$ do-release-upgrade [-d]
```

Use `-d` if upgrading before the first patch release (July).