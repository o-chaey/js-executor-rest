ARG GRAALVM_VERSION=22.2.0
FROM ghcr.io/graalvm/graalvm-ce:$GRAALVM_VERSION as donor

ARG JAVA_DIR=/opt/graalvm-ce-java17-${GRAALVM_VERSION}

RUN ["gu", "install", "js"]

RUN ["jlink", "--no-header-files", "--no-man-pages", "--compress=2", "--strip-java-debug-attributes", "--add-modules", "java.base,java.logging,java.xml,jdk.unsupported,java.desktop,java.sql,java.naming,java.management,java.instrument,java.security.jgss,jdk.crypto.ec,jdk.jcmd,org.graalvm.truffle,jdk.internal.vm.compiler,jdk.internal.vm.compiler.truffle.jfr", "--output", "/jre"]
RUN ["mkdir", "/jre/languages/"]

# cp > COPY
RUN ["cp", "-r", "/opt/graalvm-ce-java17-22.2.0/languages/icu4j/", "/jre/languages/icu4j/"]
RUN ["cp", "-r", "/opt/graalvm-ce-java17-22.2.0/languages/js/", "/jre/languages/js/"]

FROM gcr.io/distroless/base

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

ENV JAVA_HOME=${JAVA_DIR}

ENV GRAALVM_HOME=${JAVA_HOME}
ENV GRAAL_HOME=${JAVA_HOME}
ENV PATH=${PATH}:${JAVA_HOME}/bin

COPY --from=donor /jre ${JAVA_DIR}

COPY --from=donor /usr/lib64/libz.* /lib/x86_64-linux-gnu/

ENTRYPOINT ["java"]

CMD ["-XX:+UnlockExperimentalVMOptions", "-XX:+EnableJVMCI"]