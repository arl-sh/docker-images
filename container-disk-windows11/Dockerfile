FROM debian AS download

WORKDIR /disk

RUN apt-get update && apt-get install -y uuid-runtime curl

ADD ./download.sh ./
RUN ./download.sh

FROM scratch

COPY --chown=107:107 --from=download /disk/*.iso /disk/
