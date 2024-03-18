ARG BUILD_FROM
FROM $BUILD_FROM

# Define constants
ARG VERSION=3.0.7
ENV LE_CONFIG_HOME /config
ENV AUTO_UPGRADE 0

# Install dependencies
RUN apk --no-cache add openssl

# Install & initialize ACME.sh
RUN curl -L https://github.com/acmesh-official/acme.sh/archive/refs/tags/${VERSION}.tar.gz | tar -xz
RUN cd acme.sh-${VERSION} && ./acme.sh --install --no-cron
#RUN /root/.acme.sh/acme.sh --server ${CA} --set-default-ca
RUN cd / && rm -rf acme.sh-${VERSION}

# Configure image entry point
COPY run.sh /
RUN chmod a+x /run.sh
CMD [ "/run.sh" ]
