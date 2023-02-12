FROM ruby:3.2.1

# Ensure node.js 18 is available for apt-get
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libvips nodejs && npm install -g yarn

# Mount $PWD to this workdir
COPY ./ /app
WORKDIR /app

RUN bundle config set app_config .bundle
RUN bundle config set path .cache/bundle
# mount cacheを利用する
RUN --mount=type=cache,target=/app/.cache/bundle \
    bundle install && \
    mkdir -p vendor && \
    cp -ar .cache/bundle /bundle
RUN bundle config set path /bundle

RUN --mount=type=cache,target=/app/.cache/node_modules \
    yarn install --modules-folder .cache/node_modules && \
    cp -ar .cache/node_modules node_modules

RUN --mount=type=cache,target=/app/tmp/cache bin/rails assets:precompile

# 実行時にコマンド指定が無い場合に実行されるコマンド
CMD ["bin/rails", "s", "-b", "0.0.0.0"]
