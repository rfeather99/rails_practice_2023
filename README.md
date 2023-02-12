## とりあえずこれ
- Ruby: 3.2
- Rails: 7.0
- Node: 18
  - esbuild
  - typescript
  - sass
- docker

### やること
1. Dockerfileを準備
- dockedのDockerfileをぱくる

  ```dockerfile
  FROM ruby:3.2.1

  # Ensure node.js 18 is available for apt-get
  RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -

  # Install dependencies
  RUN apt-get update -qq && apt-get install -y build-essential libvips nodejs && npm install -g yarn

  # Mount $PWD to this workdir
  WORKDIR /app

  # Ensure gems are installed on a persistent volume and available as bins
  RUN bundle config set --global path '/bundle'
  ENV PATH="/bundle/ruby/3.2.0/bin:${PATH}"

  # Install Rails
  RUN gem install rails

  # Ensure binding is always 0.0.0.0, even in development, to access server from outside container
  ENV BINDING="0.0.0.0"

  # Overwrite ruby image's entrypoint to provide open cli
  ENTRYPOINT [""]
  ```

  ```yaml
  version: '3'
  services:
    web:
      build: .
      volumes:
        - .:/app
      ports:
        - "3000:3000"
      stdin_open: true
      tty: true
  ```

- docker compose run

  ```sh
  docker compose run --rm -it -v ${PWD}:/rails bash
  ```

- `rails new ./ --js esbuild --css sass`
- dockerfile修正
- docker-composeファイル作成
- DB設定

1. rubyいれる

  ```
  rbenv install 3.2.1
  ```

