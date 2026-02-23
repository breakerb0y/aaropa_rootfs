FROM devuan/migrated:ceres-slim

COPY template /
COPY packages /
COPY scripts /
COPY iso /iso

RUN apt update && apt upgrade -y

# Install additional apt utils 
RUN apt install -y apt-transport-https ca-certificates

# Re-run apt update after install apt utils
RUN apt update --allow-unauthenticated

# Install package list
RUN grep -Ev '^#' /pkglist.cfg | xargs apt install -y --no-install-recommends --no-install-suggests

RUN /post-install.sh

# Try to strip down the image further
RUN grep -Ev '^#' /rmlist.cfg | xargs dpkg --remove --force-depends --force-remove-essential || :

RUN rm /*.cfg

RUN /post-setup.sh
RUN rm /*.sh

