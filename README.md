ACM ICPC Regional (Tehran Site) Contest Image Builder
=====================================================

The Contest Image Builder contains a set of bash scripts used to build
the contest image for the ACM ICPC Regional in Tehran, Iran.

Build Live Image With Docker
----------------------------

For an isolated image building process:

  * install docker
  * go to `live` folder
  * run `make docker-run`

Build Live Image Without Docker
------------------------------

(if you think people are overusing docker and sacrifcing performance for the sake of simplicity in the development and deployment, OK, but for this specific project, it mounts some folders in *your computer* and it seems that your libraries will be added to built image. also, deleting cache folders that caused by a failed build may (in case of not unmounting) causes to temporal damages (that hopefully can be fixed by restarting) to your computer. so, build using docker)

To build a live version of the ACM ICPC contest image,
put ``ubuntu-16.04.3-desktop-amd64.iso`` in the ``live``
directory then run ``build.sh`` in there.

Install Modification Only
-------------------------

To modify *an already installed OS* to the ACM ICPC contest image (I don't think you're supposed to do this), follow the instructions below:

  * install Ubuntu 18.04.1 LTS Desktop on your system
  * create a user named ``icpc``
  * run ``sudo bash install.sh``


