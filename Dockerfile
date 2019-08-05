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
COPY .s3cfg /home/sam/.s3cfg
RUN chown sam /home/sam/.s3cfg
USER sam
RUN cd ~
RUN echo 'export PATH=$PATH:/home/sam/.local/bin' >> /home/sam/.bash_profile
RUN echo 'export PS1="\u@\h:\W\\$ \[$(tput sgr0)\]"' >> /home/sam/.bash_profile
RUN eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_rsa
RUN git config --global user.name "Sam Johnson"
RUN git config --global user.email "sam@durosoft.com"
RUN git config --global core.editor nano
RUN pip install s3cmd --user
CMD source ~/.bash_profile && cd ~ && bash
