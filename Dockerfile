# https://docs.linuxserver.io/images/docker-webtop/
# https://github.com/linuxserver/docker-webtop
# https://github.com/linuxserver/docker-webtop/releases
FROM lscr.io/linuxserver/webtop:ubuntu-kde-fc93423a-ls81

##### PORTS #####

# HTTP VNC
EXPOSE 3000
# HTTPS VNC
EXPOSE 3001

##### ENVIRONMENT VARIABLES #####

# User and Group ID
ENV PUID=1000
ENV PGID=1000

ENV HOME=/config

# Java
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

##### INSTALL PACKAGES #####

# Install additional tools: Git and OpenJDK 8
RUN apt-get update && apt-get install -y \
    nano \
	htop \
    btop \
    wget \
    unzip \
	dos2unix \
    mesa-utils \
    git \
    openjdk-21-jdk \
    libwebkit2gtk-4.1-0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Eclipse
RUN wget -O eclipse.tar.gz https://mirror.umd.edu/eclipse/technology/epp/downloads/release/2025-03/R/eclipse-modeling-2025-03-R-linux-gtk-x86_64.tar.gz && \
    mkdir -p /opt && \
    tar -xzf eclipse.tar.gz -C /opt && \
    rm eclipse.tar.gz

##### CONFIGS #####

RUN git config --global user.email "you@example.com" && \
    git config --global user.name "Your Name" && \
    git config --global init.defaultBranch main

##### CREATE DESKTOP SHORTCUTS #####

# Clear default desktop shortcuts
RUN rm -rf /home/kasm-default-profile/Desktop 

# Take ownership...
RUN chown -R $PUID:$PGID $HOME
RUN chmod -R u+rw $HOME
USER $PUID

# Ensure the Desktop directory exists
RUN mkdir -p $HOME/Desktop

# Create a desktop shortcut for RustDesk
RUN printf "[Desktop Entry]\n\
Type=Application\n\
Name=Eclipse SiDiff\n\
Exec=/opt/eclipse/eclipse -data $HOME/workspace/eclipse-workspace\n\
Icon=/opt/eclipse/icon.xpm\n\
Terminal=false\n\
Categories=Network;RemoteAccess;\n" > $HOME/Desktop/eclipse.desktop && \
    chmod +x $HOME/Desktop/eclipse.desktop

##### SIDIFF #####

# Create workspace, Git folder
RUN mkdir -p $HOME/workspace/eclipse-workspace && \
    mkdir -p $HOME/git

# Clone repositories:
RUN git clone --branch master https://github.com/manuelohrndorf/sidiff-common.git $HOME/git/sidiff-common
RUN git clone --branch main https://github.com/manuelohrndorf/sidiff-matching $HOME/git/sidiff-matching
RUN git clone --branch master https://github.com/manuelohrndorf/sidiff-lifting.git $HOME/git/sidiff-lifting
#RUN git clone --branch master https://gitlab.eclipse.org/eclipse/papyrus/org.eclipse.papyrus-classic.git

##### /config/workspace/eclipse-workspace #####

# Eclipse workbench version
COPY ./eclipse-workspace/.metadata/version.ini                                                                /config/workspace/eclipse-workspace/.metadata/version.ini
# imported workspace projects
COPY ./eclipse-workspace/.metadata/.plugins/org.eclipse.core.resources/.projects/                             /config/workspace/eclipse-workspace/.metadata/.plugins/org.eclipse.core.resources/.projects/
# snapshot of the resource tree
COPY ./eclipse-workspace/.metadata/.plugins/org.eclipse.core.resources/0.snap                                 /config/workspace/eclipse-workspace/.metadata/.plugins/org.eclipse.core.resources/0.snap
# added Git projects
COPY ./eclipse-workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.egit.core.prefs    /config/workspace/eclipse-workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.egit.core.prefs
# launch configurations
COPY ./eclipse-workspace/.metadata/.plugins/org.eclipse.debug.core/.launches/Eclipse-SiDiff.launch            /config/workspace/eclipse-workspace/.metadata/.plugins/org.eclipse.debug.core/.launches/Eclipse-SiDiff.launch
# launch configurations
COPY ./eclipse-workspace/.metadata/.plugins/org.eclipse.debug.ui/launchConfigurationHistory.xml               /config/workspace/eclipse-workspace/.metadata/.plugins/org.eclipse.debug.ui/launchConfigurationHistory.xml
# Eclipse UI layout and settings
COPY ./eclipse-workspace/.metadata/.plugins/org.eclipse.e4.workbench/workbench.xmi                            /config/workspace/eclipse-workspace/.metadata/.plugins/org.eclipse.e4.workbench/workbench.xmi
# working sets
COPY ./eclipse-workspace/.metadata/.plugins/org.eclipse.ui.workbench/workingsets.xml                          /config/workspace/eclipse-workspace/.metadata/.plugins/org.eclipse.ui.workbench/workingsets.xml

##### /config/workspace/runtime-eclipse-workspace-sidiff #####

# Eclipse workbench version
COPY ./runtime-eclipse-workspace-sidiff/.metadata/version.ini                                        /config/workspace/runtime-eclipse-workspace-sidiff/.metadata/version.ini
# imported workspace projects
COPY ./runtime-eclipse-workspace-sidiff/.metadata/.plugins/org.eclipse.core.resources/.projects/     /config/workspace/runtime-eclipse-workspace-sidiff/.metadata/.plugins/org.eclipse.core.resources/.projects/
# Eclipse UI layout and settings
COPY ./runtime-eclipse-workspace-sidiff/.metadata/.plugins/org.eclipse.e4.workbench/workbench.xmi    /config/workspace/runtime-eclipse-workspace-sidiff/.metadata/.plugins/org.eclipse.e4.workbench/workbench.xmi

USER root
RUN chown -R $PUID:$PGID /config/workspace/
