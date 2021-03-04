FROM ubuntu:20.04

# Prepare development environment
ARG NODE_VERSION=14.x
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl
RUN curl --silent --location https://deb.nodesource.com/setup_$NODE_VERSION | bash -
RUN apt-get install -y nodejs \
    build-essential \
    clang-10 \
    git
RUN ln -s /usr/bin/clang-10 /usr/bin/clang
RUN ln -s /usr/bin/clang++-10 /usr/bin/clang++
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
RUN apt-get install -y git-lfs && \
    git lfs install

RUN apt-get install -y spawn-fcgi

# Clone Bosque's sources
RUN echo "Cloning..."
RUN git clone -b master https://github.com/joelibaceta/BosqueLanguage.git bosque

#WORKDIR /bosque
#ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
#RUN git pull origin master
# Copy language tools for VSCode integration (syntax highlighting)
WORKDIR /bosque/impl
# Install Node packages
RUN npm install --global --silent typescript
RUN npm install --silent
# Make Bosque's exegen globally available
RUN npm run make-exe

WORKDIR /

RUN mkdir src
COPY . /

WORKDIR /src

RUN exegen script.bsq -o bosquebin --entrypoint "NSMain::runner"

WORKDIR /

RUN ls

RUN npm install


EXPOSE 8081
#RUN ./bosquebin -60 2 3 4 3 7 9 8 12

#CMD ["spawn-fcgi -p 8000 -n /src/a.out"]
CMD ["node", "server.js"]
