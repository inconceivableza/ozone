FROM node:20.11-alpine3.18 as build

WORKDIR /usr/src/next-runtime-env
RUN apk add git; npm install -g pnpm typescript; \
    ( git clone https://github.com/itaru2622/next-runtime-env . -b next; \
      rm -f pnpm-lock.yaml; \
      pnpm i; \
      pnpm build; \
    )


WORKDIR /usr/src/ozone

RUN corepack enable

COPY package.json yarn.lock .yarnrc.yml ./
RUN sed -i 's#"next-runtime-env": .*#"next-runtime-env": "file://usr/src/next-runtime-env",#' package.json
RUN yarn
COPY . .
RUN yarn build
RUN rm -rf node_modules .next/cache
RUN mv service/package.json package.json && mv service/yarn.lock yarn.lock
RUN yarn

# final stage

FROM node:20.11-alpine3.18

RUN apk add --update dumb-init
ENV TZ=Etc/UTC

WORKDIR /usr/src/next-runtime-env
COPY --from=build /usr/src/next-runtime-env /usr/src/next-runtime-env
RUN chown -R node:node /usr/src/next-runtime-env

WORKDIR /usr/src/ozone
COPY --from=build /usr/src/ozone /usr/src/ozone
RUN chown -R node:node .

ENTRYPOINT ["dumb-init", "--"]
EXPOSE 3000
ENV OZONE_PORT=3000
ENV NODE_ENV=production
USER node
CMD ["node", "./service"]

LABEL org.opencontainers.image.source=https://github.com/bluesky-social/ozone
LABEL org.opencontainers.image.description="Ozone Moderation Service Web UI"
LABEL org.opencontainers.image.licenses=MIT
