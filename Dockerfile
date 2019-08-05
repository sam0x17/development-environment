FROM alpine:latest
RUN apk update
RUN apk upgrade
RUN apk add git p7zip crystal shards rust cargo ncurses bash \
openssh-client openssh openssh-keygen openssh-keysign py-pip python \
nano alpine-sdk
RUN ln -fs /bin/bash /bin/sh
RUN adduser -h /home/sam -D sam
RUN echo 'sam ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
COPY .ssh /home/sam/.ssh
RUN chown -R sam /home/sam/.ssh
USER sam
RUN cd ~
RUN echo 'export PATH=$PATH:/home/sam/.local/bin' >> /home/sam/.bash_profile
RUN echo 'export PS1="\u@\h:\W\\$ \[$(tput sgr0)\]"' >> /home/sam/.bash_profile
RUN eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_rsa
RUN git config --global user.name "Sam Johnson"
RUN git config --global user.email "sam@durosoft.com"
RUN git config --global core.editor nano
CMD source ~/.bash_profile && cd ~ && bash
