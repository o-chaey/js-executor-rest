### JVM Note

Running on a stock JVM is not a supported feature as it is not supported
by one of our core dependencies GraalJS:  
(https://github.com/oracle/graaljs/blob/master/README.md)
> If you prefer running it on a stock JVM, please have a look at the documentation
> in [`RunOnJDK.md`](https://github.com/graalvm/graaljs/blob/master/docs/user/RunOnJDK.md).
> Note that in this mode many features and optimizations of GraalVM are not available.
> Due to those limitations, running on a stock JVM is not a supported feature - please use a GraalVM instead.

## Build instructions

The system consists of several major components:

1) the app itself - "js-executor"
    1) swagger-ui for manual testing and as the only client
    2) app resource server itself
2) authentication&authorization provider - keycloak
    1) keycloak itself
    2) postgresql for persistence
    3) pgadmin for managing postgre db    
       Component #2 is only meant to be built with Docker, while cmp #1 can used be both "raw" (to launch inside IDE,
       for easier debugging and iterative development etc.) and from inside a Docker container

### Common steps

0) change line `127.0.0.1  localhost` in your hosts file to `127.0.0.1  localhost keycloak`
   That is needed because KC's ssl certificate is issued for the domain "keycloak" to work
   inside Docker compose network. This might be fixed in the future by issuing a cert with
   alternative names (SAN) but attempts so far weren't successful.

### Running "raw"

1) Obtain and install GraalVM  
   a) An easy is to use SDKMAN! manager.  
   Or if you'd like to do this manually refer to https://www.graalvm.org/22.1/docs/getting-started/#install-graalvm
2) `git clone https://github.com/Daniil547/js-executor-rest.git` in a directory of your choice to download sources
3) `cd <project-root>` to enter the project root dir  
   `./mvnw compile` to build  
   `./mwnv install` to build and install into local Maven repo  
   `./mvnw spring-boot:run` to run  
   Application runs on the standard 8080 port, to run on a specific port run:
   `./mvnw spring-boot:run -Dspring-boot.run.arguments=--server.port=<port>`
4) `cd external-res`
5) `docker compose up keycloak pgadmin`

### Running fully dockerized

1) `git clone https://github.com/Daniil547/js-executor-rest.git` in a directory of your choice to download sources
2) `cd <project-root>`
3) `cd external-res`
4) `docker build -t "custom-graal-distroless" custom-graal-distroless/`
5) `cd ..`
6) `./mvnw jib:dockerBuild`
7) `cd external-res`
8) `docker compose up`

### Ports

After the system is up and running components can be accessed at (host:port):

- keycloak at `https://localhost:8443` (https, self-signed cert)
- pgadmin at `localhost:5050`
- swagger at `http://localhost:8080/swagger-ui/index.html#/` (or a port specified by you)

### Passwords

Admin account for the JS Executor itself is *app_admin*, you can find out its password
(and change it, which you should do) in KC. User accounts can be registered at will.  
Like this:  
1) press **Authorize**
2) under **Authorization (OAuth2, authorization_code)**
3) tick **openid** under **Scopes**
4) press **Authorize**
5) enter username and password or press **register** for a new user

Credentials for other services (KC, Postgre DB, PGAdmin) are to be defined in
external-res/users.env. Here's an example of such file, you only need to usernames and passwords:

```
# for access to KC amin console
KEYCLOAK_ADMIN=
KEYCLOAK_ADMIN_PASSWORD=

# for access to the pgadmin console
# it accepts email instead of username
PGADMIN_DEFAULT_EMAIL=
PGADMIN_DEFAULT_PASSWORD=

# for access to the DB
POSTGRES_USER=
POSTGRES_PASSWORD=

# for KC to access the DB
# these must mirror POSTGRES_USER and POSTGRES_PASSWORD
KC_DB_USERNAME=$POSTGRES_USER
KC_DB_PASSWORD=$POSTGRES_PASSWORD
```