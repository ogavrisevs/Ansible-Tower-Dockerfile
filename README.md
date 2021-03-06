This container consists of Ansible Tower installation.

![](https://raw.githubusercontent.com/ogavrisevs/Ansible-Tower-Dockerfile/master/pic/ansible_tower_logo.png "Ansible Tower")

Cureentl we support following tags :

* [latest](https://github.com/ogavrisevs/Ansible-Tower-Dockerfile/blob/master/Dockerfile)

* [2.1.3](https://github.com/ogavrisevs/Ansible-Tower-Dockerfile/blob/master/Dockerfile)


Ansible is installed from official distributive.
As base box is used [Centos:6](
https://github.com/CentOS/sig-cloud-instance-images/blob/e83bb5bf3b38bda254b46908234999355265cd96/docker/Dockerfile).

You can rebuild image with :

    docker build --rm -t tower:2.1.3 .

You can run ( demonised ) Ansible tower with :

    docker run  --name tower -p 8080:443 -d tower:2.1.3

(dont forget we exposed secure http so you need to add "https" to url in browser ) -> https://docker_host_ip:8080

Ansible Tower installation itself consists of :

  * postgresql 8.4.20-2
  * redis 2.8.19-2
  * httpd  2.2.15-39
  * supervisord 2.1-9

Default Ansible Tower user/ pass is : "admin:password".

You can change default passwords in "tower_setup_conf.yml" file :

  * admin_password - Ansible Tower password
  * munin_password - Munin monitoring password
  * redis_password - Redis data structure server password
  * pg_password - PostgreSQL password
