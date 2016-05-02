#pull base source
FROM jimmyrosa/sunodejs

#update respos an install software
RUN apt-get update
RUN apt-get install -y apache2 nano curl

#set Apache to start on boot
RUN echo "service apache2 start" >> /etc/bash.bashrc

ADD . /home/app/portal