# ## https://github.com/microsoft/mssql-docker/blob/master/linux/mssql-server-linux/Dockerfile
# ## https://github.com/microsoft/mssql-docker/blob/master/linux/preview/examples/mssql-agent-fts-ha-tools/Dockerfile

# # mssql-server-linux
# # Maintainers: Microsoft Corporation (LuisBosquez and twright-msft on GitHub)
# # GitRepo: https://github.com/Microsoft/mssql-docker

# https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-ubuntu

# Base OS layer: Latest Ubuntu LTS.
FROM ubuntu:22.04

# Default SQL Server TCP/Port.
EXPOSE 1433

# Install prerequistes since it is needed to get repo config for SQL server
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -yq curl apt-transport-https && \
    # Get official Microsoft repository configuration
    curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc && \
    curl https://packages.microsoft.com/config/ubuntu/22.04/mssql-server-2022.list | tee /etc/apt/sources.list.d/mssql-server-2022.list && \
    apt-get update && \
    # Install SQL Server from apt
    apt-get install -y mssql-server && \
    # Install optional packages
    apt-get install -y mssql-server-ha && \
    apt-get install -y mssql-server-fts && \
    # Cleanup the Dockerfile
    apt-get clean && \
    rm -rf /var/lib/apt/lists

# adding custom MS repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc
RUN curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list > /etc/apt/sources.list.d/mssql-server-2022.list

# install SQL Server tools
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

# Run SQL Server process
CMD /opt/mssql/bin/sqlservr
