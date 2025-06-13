FROM httpd:alpine
EXPOSE 80
RUN apk add make bash
COPY ./src/ /src/
RUN cp -r /src /build
WORKDIR /build/
RUN bash -c make
RUN cp -r html/* /usr/local/apache2/htdocs/
WORKDIR /usr/local/apache2/

