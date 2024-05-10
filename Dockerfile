FROM cypress/base:20.5.0 as test-env

# Upgrade Yarn
ENV YARN_VERSION 4.0.2

RUN yarn policies set-version $YARN_VERSION

WORKDIR /app
COPY . /app
RUN yarn install
RUN yarn build # Need to build here because e2e needs the showcase package to be built

# Publish Environment
FROM hobsons-cfcr-docker.jfrog.io/hobsons/jfrog_npm_wrapper:STABLE as publish-env
COPY --from=test-env /app/modules/react-arborist /app
COPY --from=test-env /app/.npmrc /app/.npmrc
WORKDIR /app
#RUN yarn info
