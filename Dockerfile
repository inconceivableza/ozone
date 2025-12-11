FROM node:20.11-alpine3.18 as build

WORKDIR /usr/src/next-runtime-env
RUN apk add git; npm install -g pnpm typescript; \
    ( git clone https://github.com/itaru2622/next-runtime-env . -b next; \
      rm -f pnpm-lock.yaml; \
      pnpm i; \
      pnpm build; \
    )

WORKDIR /usr/src/ozone/submodules/atproto/

RUN corepack enable

COPY submodules/atproto/tsconfig ./tsconfig
COPY submodules/atproto/package.json ./package.json
COPY submodules/atproto/pnpm-lock.yaml ./pnpm-lock.yaml
COPY submodules/atproto/pnpm-workspace.yaml ./pnpm-workspace.yaml

# pnpm list -F api... -F oauth-client-browser... -F oauth-types... -F xrpc... --parseable --only-projects | sed 's#^.*atproto/##'
# Paths must match pnpm-workspace.yaml: packages/*, packages/oauth/*, packages/internal/*
COPY submodules/atproto/packages/api/package.json ./packages/api/package.json
COPY submodules/atproto/packages/common-web/package.json ./packages/common-web/package.json
COPY submodules/atproto/packages/lex-cli/package.json ./packages/lex-cli/package.json
COPY submodules/atproto/packages/lexicon/package.json ./packages/lexicon/package.json
COPY submodules/atproto/packages/syntax/package.json ./packages/syntax/package.json
COPY submodules/atproto/packages/xrpc/package.json ./packages/xrpc/package.json
COPY submodules/atproto/packages/did/package.json ./packages/did/package.json
COPY submodules/atproto/packages/oauth/oauth-client-browser/package.json ./packages/oauth/oauth-client-browser/package.json
COPY submodules/atproto/packages/oauth/oauth-client/package.json ./packages/oauth/oauth-client/package.json
COPY submodules/atproto/packages/oauth/oauth-types/package.json ./packages/oauth/oauth-types/package.json
COPY submodules/atproto/packages/oauth/jwk/package.json ./packages/oauth/jwk/package.json
COPY submodules/atproto/packages/oauth/jwk-webcrypto/package.json ./packages/oauth/jwk-webcrypto/package.json
COPY submodules/atproto/packages/oauth/jwk-jose/package.json ./packages/oauth/jwk-jose/package.json
COPY submodules/atproto/packages/internal/did-resolver/package.json ./packages/internal/did-resolver/package.json
COPY submodules/atproto/packages/internal/handle-resolver/package.json ./packages/internal/handle-resolver/package.json
COPY submodules/atproto/packages/internal/simple-store/package.json ./packages/internal/simple-store/package.json
COPY submodules/atproto/packages/internal/simple-store-memory/package.json ./packages/internal/simple-store-memory/package.json
COPY submodules/atproto/packages/internal/fetch/package.json ./packages/internal/fetch/package.json
COPY submodules/atproto/packages/internal/pipe/package.json ./packages/internal/pipe/package.json
COPY submodules/atproto/packages/internal/identity-resolver/package.json ./packages/internal/identity-resolver/package.json

RUN --mount=type=cache,id=pnpm,target=/root/.local/share/pnpm/store \
  pnpm install --frozen-lockfile

WORKDIR /usr/src/ozone

RUN corepack enable

COPY package.json yarn.lock .yarnrc.yml ./
RUN sed -i 's#"next-runtime-env": .*#"next-runtime-env": "file://usr/src/next-runtime-env",#' package.json

RUN yarn
RUN yarn atproto:install
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
