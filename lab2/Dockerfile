FROM ubuntu
COPY . /app
WORKDIR /app
RUN chmod +x /app/main.sh
CMD ["/app/main.sh"]
VOLUME ["/shared_volume"]
