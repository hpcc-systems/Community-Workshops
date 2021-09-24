FROM gitpod/workspace-full

# Install the latest hpccsystems clienttools.
RUN cd /tmp \
 && wget https://cdn.hpccsystems.com/releases/CE-Candidate-8.0.14/bin/clienttools/hpccsystems-clienttools-community_8.0.14-1focal_amd64.deb \
 && sudo apt-get -y update \
 && sudo apt-get install -y --fix-missing ./hpccsystems-clienttools-community_8.0.14-1focal_amd64.deb \
 && rm -f hpccsystems-clienttools-community_8.0.14-1focal_amd64.deb