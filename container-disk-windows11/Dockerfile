ARG FILE_NAME=Win11_English.iso

FROM debian AS download

ARG FILE_NAME

WORKDIR /disk

RUN apt-get update && apt-get install -y uuid-runtime curl

ADD ./download.sh ./
RUN ./download.sh $FILE_NAME

FROM scratch

ARG FILE_NAME

COPY --chown=107:107 --from=download /disk/$FILE_NAME /disk/
