FROM gitpod/workspace-full

# Install the latest hpccsystems clienttools.
RUN cd /tmp \
 && wget https://cdn.hpccsystems.com/releases/CE-Candidate-8.2.0/bin/clienttools/hpccsystems-clienttools-community_8.2.0-1groovy_amd64.deb \
 && sudo apt-get -y update \
 && sudo apt-get install -y --fix-missing ./hpccsystems-clienttools-community_8.2.0-1groovy_amd64.deb \
 && rm -f hpccsystems-clienttools-community_8.2.0-1groovy_amd64.deb