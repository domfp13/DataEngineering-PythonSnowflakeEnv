# Python Snowflake Environment

This a portable microservice environment that contains all the necessary dependencies to connect to snowflake using its native component of python drivers. It includes the following files and folders.

- src - Python modules and a sample method to connect to Snowflake.
- Makefile - Target recipes that will spin up the environment.

The application contains the Dockerfile and docker-compose that will manage the container

## Setup

This application uses Docker container to run the code.

You need the following tools:

* Docker - [Install Docker](https://hub.docker.com/search/?type=edition&offering=community)
* Docker Compose - [Installe Docker Compose](https://docs.docker.com/compose/install/)

Optional for Windows:

* Gitbash - [Install Gitbash](https://git-scm.com/downloads)
* Make - [Install Make](https://www.youtube.com/watch?v=taCJhnBXG_w)

First make sure you add your Snowflake credentials on the *.env* directory, the directory has the following environmental variables:
* SNOWFLAKE_ACCOUNTNAME
* SNOWFLAKE_USERNAME
* SNOWFLAKE_PASSWORD
* SNOWFLAKE_DBNAME
* SNOWFLAKE_WAREHOUSENAME
* SNOWFLAKE_ROLENAME
* SNOWFLAKE_SCHEMANAME

Once you add your credentials to create all the services run:

```bash
$ make start
```

To run the code in *src* run one of the followings depending on your OS. If you are in windows you will need to have also GitBash and install Make.
```bash
$ make run-code-l (unix os)
$ make run-code-w (windows os)
```

To stop all the services trashing the container symply run:
```bash
$ make stop
```

## Authors
* **Luis Enrique Fuentes Plata** - *2021-05-04*
