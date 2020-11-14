FROM  hshar/webapp

ADD /home/ubuntu/serverinfo.html  /var/www/html
ADD ./index.html  /var/www/html
RUN mkdir /var/www/html/images
ADD ./images/github3.jpg  /var/www/html/images


