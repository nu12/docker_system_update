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