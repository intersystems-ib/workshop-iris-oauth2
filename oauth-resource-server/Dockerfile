ARG IMAGE=containers.intersystems.com/intersystems/iris-community:latest-cd
FROM $IMAGE

USER root

# change ownership
RUN mkdir -p /opt/irisapp
RUN chown -R ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp
WORKDIR /opt/irisapp

USER ${ISC_PACKAGE_MGRUSER}

# copy source
COPY iris.script iris.script
COPY src src
COPY install install

# download zpm package manager
#RUN mkdir -p /tmp/deps \
# && cd /tmp/deps \
# && wget -q https://pm.community.intersystems.com/packages/zpm/latest/installer -O zpm.xml

# run iris.script
RUN iris start IRIS \
    && iris session IRIS < /opt/irisapp/iris.script \
    && iris stop IRIS quietly