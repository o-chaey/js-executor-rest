### JVM Note

Running on a stock JVM is not a supported feature as it is not supported
by one of our core dependencies GraalJS:  
(https://github.com/oracle/graaljs/blob/master/README.md)
> If you prefer running it on a stock JVM, please have a look at the documentation
> in [`RunOnJDK.md`](https://github.com/graalvm/graaljs/blob/master/docs/user/RunOnJDK.md).
> Note that in this mode many features and optimizations of GraalVM are not available.
> Due to those limitations, running on a stock JVM is not a supported feature - please use a GraalVM instead.

### Build instructions

1) Obtain and install GraalVM  
   a) An easy is to use SDKMAN! manager.  
   Or if you'd like to do this manually refer to https://www.graalvm.org/22.1/docs/getting-started/#install-graalvm
2) `git clone https://github.com/Daniil547/js-executor-rest.git` in a directory of your choice to download sources
3) `cd js-executor-rest` to enter the project root dir  
   `./mvnw compile` to build  
   `./mwnv install` to build and install into local Maven repo  
   `./mvnw spring-boot:run` to run  
   Application runs on the standard 8080 port, to run on a specific port run:
   `./mvnw spring-boot:run -Dspring-boot.run.arguments=--server.port=<port>`