FROM ubuntu:bionic

# wrapper script for apt-get
COPY .docker/apt-get-install /usr/local/bin/apt-get-install
RUN chmod +x /usr/local/bin/apt-get-install

RUN apt-get-install build-essential libtool g++ gcc \
    texinfo curl wget automake autoconf python python-dev git subversion \
    unzip virtualenvwrapper sudo  git virtualenvwrapper ca-certificates \
    flex bison libglib2.0-dev libcurl-openssl-dev binutils-dev libunwind-dev ssh \
    libsqlite3-dev cmake

RUN useradd -m ctf
RUN echo "ctf ALL=NOPASSWD: ALL" > /etc/sudoers.d/ctf

COPY .git /home/ctf/tools/.git
RUN chown -R ctf.ctf /home/ctf/tools

# git checkout of the files
USER ctf
WORKDIR /home/ctf/tools
RUN git checkout .

# add non-commited scripts
USER root
COPY bin/manage-tools /home/ctf/tools/bin/
COPY bin/ctf-tools-pip /home/ctf/tools/bin/
COPY bin/ctf-tools-venv-activate /home/ctf/tools/bin/
COPY bin/ctf-tools-venv-activate3 /home/ctf/tools/bin/
RUN chown -R ctf.ctf /home/ctf/tools
# finally run ctf-tools setup
USER ctf
RUN bin/manage-tools -s setup
RUN bin/ctf-tools-pip install appdirs
RUN echo 'source /home/ctf/tools/bin/ctf-tools-venv-activate' >> /home/ctf/.bashrc
RUN bash -c 'set -x; for t in afl binwalk capstone checksec dirb dirsearch honggfuzz lief littleblackbox manticore miasm pdf-parser peepdf rr scrdec18 snowman subbrute unicorn valgrind wcc; do PATH=/home/ctf/tools/bin:$PATH bin/manage-tools install $t; done' 
#RUN bin/manage-tools install binwalk
#RUN bin/manage-tools install capstone
#RUN bin/manage-tools install checksec
#RUN bin/manage-tools install dirb
#RUN bin/manage-tools install dirsearch
#RUN bin/manage-tools install gdb
#RUN bin/manage-tools install gef
#RUN bin/manage-tools install honggfuzz
#RUN bin/manage-tools install lief
#RUN bin/manage-tools install littleblackbox
#RUN bin/manage-tools install manticore
#RUN bin/manage-tools install miasm
#RUN bin/manage-tools install panda
#RUN bin/manage-tools install pdf-parser
#RUN bin/manage-tools install peepdf
#RUN bin/manage-tools install pwntools
#RUN bin/manage-tools install qemu
#RUN bin/manage-tools install qira
#RUN bin/manage-tools install radare2
#RUN bin/manage-tools install rr
#RUN bin/manage-tools install scrdec18
#RUN bin/manage-tools install snowman
#RUN bin/manage-tools install sqlmap
#RUN bin/manage-tools install subbrute
#RUN bin/manage-tools install unicorn
#RUN bin/manage-tools install valgrind
#RUN bin/manage-tools install wcc
WORKDIR /home/ctf
CMD bash -i
