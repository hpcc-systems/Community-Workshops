FROM gitpod/workspace-full

RUN sudo apt-get -y update

# Install the latest hpccsystems clienttools.
WORKDIR /tmp

RUN wget https://cdn.hpccsystems.com/releases/CE-Candidate-8.0.14/bin/clienttools/hpccsystems-clienttools-community_8.0.14-1focal_amd64.deb
RUN sudo apt-get install -y --fix-missing ./hpccsystems-clienttools-community_8.0.14-1focal_amd64.deb
RUN rm -f hpccsystems-clienttools-community_8.0.14-1focal_amd64.deb