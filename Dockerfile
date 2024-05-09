FROM node:20.5-alpine as test-env
RUN apk add --no-cache bash
WORKDIR /app
# Add deps to project root
COPY package* .npmrc* yarn.lock /app/
RUN yarn
RUN yarn build # Need to build here because e2e needs the showcase package to be built
COPY . /app

# Publish Environment
FROM hobsons-cfcr-docker.jfrog.io/hobsons/jfrog_npm_wrapper:STABLE as publish-env
COPY --from=test-env /app/modules/react-arborist /app
COPY --from=test-env /app/.npmrc /app/.npmrc
WORKDIR /app
RUN npm run info
