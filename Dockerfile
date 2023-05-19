FROM nginx:latest
LABEL ifeng fscarmen mack-a ygkkk
WORKDIR /LDBLZY
EXPOSE 80
USER root
ENV uuid 25ba585a-b671-4516-b03c-a3663e837243
COPY nginx.conf /etc/nginx/nginx.conf
COPY config.json ./
COPY entrypoint.sh ./
RUN chmod a+x ./entrypoint.sh
ENTRYPOINT [ "./entrypoint.sh" ]
