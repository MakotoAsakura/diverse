FROM ruby:3.0.1
ENV TZ="Asia/Tokyo"
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
		apt-get update && apt-get install -qq -y \
	  build-essential libpq-dev zlib1g-dev liblzma-dev nodejs yarn
WORKDIR /app
COPY Gemfile* ./
RUN bundle config set path "/bundle"
RUN bundle check || bundle install
COPY . .
COPY "deployments/development/docker-entrypoint.sh" /usr/bin/
RUN chmod +x "/usr/bin/docker-entrypoint.sh"
ENTRYPOINT ["docker-entrypoint.sh"]
