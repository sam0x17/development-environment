FROM alpine:edge
ARG SYSTEM_USER_NAME
ARG GIT_USER_NAME
ARG GIT_USER_EMAIL
RUN apk update
RUN apk upgrade
RUN apk add --update --no-cache --force-overwrite \
git p7zip rust cargo ncurses bash openssh-client \
openssh openssh-keygen openssh-keysign py-pip python \
nano alpine-sdk nodejs npm yarn strace openssl \
openssl-dev crystal shards g++ gc-dev libc-dev \
libevent-dev libxml2-dev llvm llvm-dev llvm-static \
make pcre-dev readline-dev yaml-dev zlib-dev zlib \
curl wget
RUN ln -fs /bin/bash /bin/sh
RUN adduser -h /home/$SYSTEM_USER_NAME -D $SYSTEM_USER_NAME
RUN echo "$SYSTEM_USER_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
COPY .ssh /home/$SYSTEM_USER_NAME/.ssh
RUN rm /home/$SYSTEM_USER_NAME/.ssh/config
RUN chown -R $SYSTEM_USER_NAME /home/$SYSTEM_USER_NAME/.ssh
COPY .s3cfg /home/$SYSTEM_USER_NAME/.s3cfg
RUN chown $SYSTEM_USER_NAME /home/$SYSTEM_USER_NAME/.s3cfg
RUN npm install -g pkg
USER $SYSTEM_USER_NAME
WORKDIR /home/$SYSTEM_USER_NAME
RUN echo "export PATH=\$PATH:/home/$SYSTEM_USER_NAME/.local/bin" >> /home/$SYSTEM_USER_NAME/.bash_profile
RUN echo "export PS1=\"\u@\h:\W\\$ \[\$(tput sgr0)\]\"" >> /home/$SYSTEM_USER_NAME/.bash_profile
RUN eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_rsa
RUN git config --global user.name "$GIT_USER_NAME"
RUN git config --global user.email "$GIT_USER_EMAIL"
RUN git config --global core.editor nano
RUN pip install s3cmd --user
RUN curl -o- https://raw.githubusercontent.com/sam0x17/conduit/master/install.sh | bash
RUN /home/$SYSTEM_USER_NAME/.conduit/conduit
CMD source ~/.bashrc && source ~/.bash_profile && bash
