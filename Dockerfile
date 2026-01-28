# syntax=docker/dockerfile:1.7-labs
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
COPY submodules/atproto/.npmrc ./.npmrc
COPY submodules/atproto/package.json ./package.json
COPY submodules/atproto/pnpm-lock.yaml ./pnpm-lock.yaml
COPY submodules/atproto/pnpm-workspace.yaml ./pnpm-workspace.yaml

# NOTE ozones's transitive dependencies go here: if that changes, this needs to be updated.
# pnpm ls --only-projects --parseable -F api... -F oauth-client-browser... -F oauth-types... -F xrpc... -F ozone... | sed 's#^.*atproto/##' | sed 's#^\(.*\)$#COPY ./submodules/atproto/\1/package.json ./\1/package.json#'
COPY ./submodules/atproto/packages/api/package.json ./packages/api/package.json
COPY ./submodules/atproto/packages/common-web/package.json ./packages/common-web/package.json
COPY ./submodules/atproto/packages/lex-cli/package.json ./packages/lex-cli/package.json
COPY ./submodules/atproto/packages/lexicon/package.json ./packages/lexicon/package.json
COPY ./submodules/atproto/packages/syntax/package.json ./packages/syntax/package.json
COPY ./submodules/atproto/packages/xrpc/package.json ./packages/xrpc/package.json
COPY ./submodules/atproto/packages/common-web/package.json ./packages/common-web/package.json
COPY ./submodules/atproto/packages/lex/lex-data/package.json ./packages/lex/lex-data/package.json
COPY ./submodules/atproto/packages/lex/lex-json/package.json ./packages/lex/lex-json/package.json
COPY ./submodules/atproto/packages/oauth/oauth-client-browser/package.json ./packages/oauth/oauth-client-browser/package.json
COPY ./submodules/atproto/packages/internal/did-resolver/package.json ./packages/internal/did-resolver/package.json
COPY ./submodules/atproto/packages/internal/handle-resolver/package.json ./packages/internal/handle-resolver/package.json
COPY ./submodules/atproto/packages/internal/simple-store/package.json ./packages/internal/simple-store/package.json
COPY ./submodules/atproto/packages/did/package.json ./packages/did/package.json
COPY ./submodules/atproto/packages/oauth/jwk/package.json ./packages/oauth/jwk/package.json
COPY ./submodules/atproto/packages/oauth/jwk-webcrypto/package.json ./packages/oauth/jwk-webcrypto/package.json
COPY ./submodules/atproto/packages/oauth/oauth-client/package.json ./packages/oauth/oauth-client/package.json
COPY ./submodules/atproto/packages/oauth/oauth-types/package.json ./packages/oauth/oauth-types/package.json
COPY ./submodules/atproto/packages/internal/did-resolver/package.json ./packages/internal/did-resolver/package.json
COPY ./submodules/atproto/packages/internal/fetch/package.json ./packages/internal/fetch/package.json
COPY ./submodules/atproto/packages/internal/pipe/package.json ./packages/internal/pipe/package.json
COPY ./submodules/atproto/packages/internal/simple-store-memory/package.json ./packages/internal/simple-store-memory/package.json
COPY ./submodules/atproto/packages/oauth/jwk-webcrypto/package.json ./packages/oauth/jwk-webcrypto/package.json
COPY ./submodules/atproto/packages/oauth/jwk-jose/package.json ./packages/oauth/jwk-jose/package.json
COPY ./submodules/atproto/packages/oauth/oauth-client/package.json ./packages/oauth/oauth-client/package.json
COPY ./submodules/atproto/packages/internal/identity-resolver/package.json ./packages/internal/identity-resolver/package.json
COPY ./submodules/atproto/packages/ozone/package.json ./packages/ozone/package.json
COPY ./submodules/atproto/packages/api/package.json ./packages/api/package.json
COPY ./submodules/atproto/packages/common/package.json ./packages/common/package.json
COPY ./submodules/atproto/packages/crypto/package.json ./packages/crypto/package.json
COPY ./submodules/atproto/packages/identity/package.json ./packages/identity/package.json
COPY ./submodules/atproto/packages/pds/package.json ./packages/pds/package.json
COPY ./submodules/atproto/packages/ws-client/package.json ./packages/ws-client/package.json
COPY ./submodules/atproto/packages/xrpc-server/package.json ./packages/xrpc-server/package.json
COPY ./submodules/atproto/packages/pds/package.json ./packages/pds/package.json
COPY ./submodules/atproto/packages/internal/fetch-node/package.json ./packages/internal/fetch-node/package.json
COPY ./submodules/atproto/packages/internal/simple-store-redis/package.json ./packages/internal/simple-store-redis/package.json
COPY ./submodules/atproto/packages/internal/xrpc-utils/package.json ./packages/internal/xrpc-utils/package.json
COPY ./submodules/atproto/packages/aws/package.json ./packages/aws/package.json
COPY ./submodules/atproto/packages/bsky/package.json ./packages/bsky/package.json
COPY ./submodules/atproto/packages/lex/lex-cbor/package.json ./packages/lex/lex-cbor/package.json
COPY ./submodules/atproto/packages/oauth/oauth-client-browser-example/package.json ./packages/oauth/oauth-client-browser-example/package.json
COPY ./submodules/atproto/packages/oauth/oauth-provider/package.json ./packages/oauth/oauth-provider/package.json
COPY ./submodules/atproto/packages/oauth/oauth-scopes/package.json ./packages/oauth/oauth-scopes/package.json
COPY ./submodules/atproto/packages/repo/package.json ./packages/repo/package.json
COPY ./submodules/atproto/packages/bsky/package.json ./packages/bsky/package.json
COPY ./submodules/atproto/packages/sync/package.json ./packages/sync/package.json
COPY ./submodules/atproto/packages/oauth/oauth-client-browser-example/package.json ./packages/oauth/oauth-client-browser-example/package.json
COPY ./submodules/atproto/packages/internal/rollup-plugin-bundle-manifest/package.json ./packages/internal/rollup-plugin-bundle-manifest/package.json
COPY ./submodules/atproto/packages/lex/lex/package.json ./packages/lex/lex/package.json
COPY ./submodules/atproto/packages/oauth/oauth-client-browser/package.json ./packages/oauth/oauth-client-browser/package.json
COPY ./submodules/atproto/packages/lex/lex/package.json ./packages/lex/lex/package.json
COPY ./submodules/atproto/packages/lex/lex-builder/package.json ./packages/lex/lex-builder/package.json
COPY ./submodules/atproto/packages/lex/lex-client/package.json ./packages/lex/lex-client/package.json
COPY ./submodules/atproto/packages/lex/lex-installer/package.json ./packages/lex/lex-installer/package.json
COPY ./submodules/atproto/packages/lex/lex-schema/package.json ./packages/lex/lex-schema/package.json
COPY ./submodules/atproto/packages/lex/lex-builder/package.json ./packages/lex/lex-builder/package.json
COPY ./submodules/atproto/packages/lex/lex-document/package.json ./packages/lex/lex-document/package.json
COPY ./submodules/atproto/packages/lex/lex-installer/package.json ./packages/lex/lex-installer/package.json
COPY ./submodules/atproto/packages/lex/lex-resolver/package.json ./packages/lex/lex-resolver/package.json
COPY ./submodules/atproto/packages/oauth/oauth-provider/package.json ./packages/oauth/oauth-provider/package.json
COPY ./submodules/atproto/packages/oauth/oauth-provider-api/package.json ./packages/oauth/oauth-provider-api/package.json
COPY ./submodules/atproto/packages/oauth/oauth-provider-frontend/package.json ./packages/oauth/oauth-provider-frontend/package.json
COPY ./submodules/atproto/packages/oauth/oauth-provider-ui/package.json ./packages/oauth/oauth-provider-ui/package.json

RUN --mount=type=cache,id=pnpm,target=/root/.local/share/pnpm/store \
  pnpm install --frozen-lockfile

COPY ./submodules/atproto/*.js* ./
COPY ./submodules/atproto/lexicons ./lexicons
# NOTE matching transitive dependencies from above
# pnpm ls --only-projects --parseable -F api... -F oauth-client-browser... -F oauth-types... -F xrpc... -F ozone... | sed 's#^.*atproto/##' | sed 's#^\(.*\)$#COPY ./submodules/atproto/\1 ./\1#'
COPY ./submodules/atproto/packages/api ./packages/api
COPY ./submodules/atproto/packages/common-web ./packages/common-web
COPY ./submodules/atproto/packages/lex-cli ./packages/lex-cli
COPY ./submodules/atproto/packages/lexicon ./packages/lexicon
COPY ./submodules/atproto/packages/syntax ./packages/syntax
COPY ./submodules/atproto/packages/xrpc ./packages/xrpc
COPY ./submodules/atproto/packages/common-web ./packages/common-web
COPY ./submodules/atproto/packages/lex/lex-data ./packages/lex/lex-data
COPY ./submodules/atproto/packages/lex/lex-json ./packages/lex/lex-json
COPY ./submodules/atproto/packages/oauth/oauth-client-browser ./packages/oauth/oauth-client-browser
COPY ./submodules/atproto/packages/internal/did-resolver ./packages/internal/did-resolver
COPY ./submodules/atproto/packages/internal/handle-resolver ./packages/internal/handle-resolver
COPY ./submodules/atproto/packages/internal/simple-store ./packages/internal/simple-store
COPY ./submodules/atproto/packages/did ./packages/did
COPY ./submodules/atproto/packages/oauth/jwk ./packages/oauth/jwk
COPY ./submodules/atproto/packages/oauth/jwk-webcrypto ./packages/oauth/jwk-webcrypto
COPY ./submodules/atproto/packages/oauth/oauth-client ./packages/oauth/oauth-client
COPY ./submodules/atproto/packages/oauth/oauth-types ./packages/oauth/oauth-types
COPY ./submodules/atproto/packages/internal/did-resolver ./packages/internal/did-resolver
COPY ./submodules/atproto/packages/internal/fetch ./packages/internal/fetch
COPY ./submodules/atproto/packages/internal/pipe ./packages/internal/pipe
COPY ./submodules/atproto/packages/internal/simple-store-memory ./packages/internal/simple-store-memory
COPY ./submodules/atproto/packages/oauth/jwk-webcrypto ./packages/oauth/jwk-webcrypto
COPY ./submodules/atproto/packages/oauth/jwk-jose ./packages/oauth/jwk-jose
COPY ./submodules/atproto/packages/oauth/oauth-client ./packages/oauth/oauth-client
COPY ./submodules/atproto/packages/internal/identity-resolver ./packages/internal/identity-resolver
COPY ./submodules/atproto/packages/ozone ./packages/ozone
COPY ./submodules/atproto/packages/api ./packages/api
COPY ./submodules/atproto/packages/common ./packages/common
COPY ./submodules/atproto/packages/crypto ./packages/crypto
COPY ./submodules/atproto/packages/identity ./packages/identity
COPY ./submodules/atproto/packages/pds ./packages/pds
COPY ./submodules/atproto/packages/ws-client ./packages/ws-client
COPY ./submodules/atproto/packages/xrpc-server ./packages/xrpc-server
COPY ./submodules/atproto/packages/pds ./packages/pds
COPY ./submodules/atproto/packages/internal/fetch-node ./packages/internal/fetch-node
COPY ./submodules/atproto/packages/internal/simple-store-redis ./packages/internal/simple-store-redis
COPY ./submodules/atproto/packages/internal/xrpc-utils ./packages/internal/xrpc-utils
COPY ./submodules/atproto/packages/aws ./packages/aws
COPY ./submodules/atproto/packages/bsky ./packages/bsky
COPY ./submodules/atproto/packages/lex/lex-cbor ./packages/lex/lex-cbor
COPY ./submodules/atproto/packages/oauth/oauth-client-browser-example ./packages/oauth/oauth-client-browser-example
COPY ./submodules/atproto/packages/oauth/oauth-provider ./packages/oauth/oauth-provider
COPY ./submodules/atproto/packages/oauth/oauth-scopes ./packages/oauth/oauth-scopes
COPY ./submodules/atproto/packages/repo ./packages/repo
COPY ./submodules/atproto/packages/bsky ./packages/bsky
COPY ./submodules/atproto/packages/sync ./packages/sync
COPY ./submodules/atproto/packages/oauth/oauth-client-browser-example ./packages/oauth/oauth-client-browser-example
COPY ./submodules/atproto/packages/internal/rollup-plugin-bundle-manifest ./packages/internal/rollup-plugin-bundle-manifest
COPY ./submodules/atproto/packages/lex/lex ./packages/lex/lex
COPY ./submodules/atproto/packages/oauth/oauth-client-browser ./packages/oauth/oauth-client-browser
COPY ./submodules/atproto/packages/lex/lex ./packages/lex/lex
COPY ./submodules/atproto/packages/lex/lex-builder ./packages/lex/lex-builder
COPY ./submodules/atproto/packages/lex/lex-client ./packages/lex/lex-client
COPY ./submodules/atproto/packages/lex/lex-installer ./packages/lex/lex-installer
COPY ./submodules/atproto/packages/lex/lex-schema ./packages/lex/lex-schema
COPY ./submodules/atproto/packages/lex/lex-builder ./packages/lex/lex-builder
COPY ./submodules/atproto/packages/lex/lex-document ./packages/lex/lex-document
COPY ./submodules/atproto/packages/lex/lex-installer ./packages/lex/lex-installer
COPY ./submodules/atproto/packages/lex/lex-resolver ./packages/lex/lex-resolver
COPY ./submodules/atproto/packages/oauth/oauth-provider ./packages/oauth/oauth-provider
COPY ./submodules/atproto/packages/oauth/oauth-provider-api ./packages/oauth/oauth-provider-api
COPY ./submodules/atproto/packages/oauth/oauth-provider-frontend ./packages/oauth/oauth-provider-frontend
COPY ./submodules/atproto/packages/oauth/oauth-provider-ui ./packages/oauth/oauth-provider-ui

WORKDIR /usr/src/ozone

RUN corepack enable

COPY package.json yarn.lock .yarnrc.yml ./
RUN sed -i 's#"next-runtime-env": .*#"next-runtime-env": "file://usr/src/next-runtime-env",#' package.json

RUN yarn
RUN yarn atproto:install

WORKDIR /usr/src/ozone/service
COPY ./service/package.json ./service/yarn.lock ./service/.yarnrc.yml ./
RUN yarn

WORKDIR /usr/src/ozone
COPY --exclude=submodules --exclude=node_modules --exclude=service --exclude=".*" . .
RUN yarn build
RUN rm -rf .next/cache
RUN rm -rf .yarn/cache
RUN rm -fr node_modules

WORKDIR /usr/src/ozone/service
COPY ./service/*.js ./
RUN yarn build
RUN rm -rf .yarn/cache

WORKDIR /usr/src/ozone
RUN ln -s ./service/node_modules ./node_modules
# final stage

FROM node:20.11-alpine3.18

RUN apk add --update dumb-init
ENV TZ=Etc/UTC

USER node:node

WORKDIR /usr/src/ozone
COPY --from=build /usr/src/ozone /usr/src/ozone

ENTRYPOINT ["dumb-init", "--"]
EXPOSE 3000
ENV OZONE_PORT=3000
ENV NODE_ENV=production
USER node
CMD ["node", "./service"]

LABEL org.opencontainers.image.source=https://github.com/bluesky-social/ozone
LABEL org.opencontainers.image.description="Ozone Moderation Service Web UI"
LABEL org.opencontainers.image.licenses=MIT
