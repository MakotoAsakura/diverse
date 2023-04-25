init:
	echo "4526b85982f56038cb42eaa299f4755f" > ../../config/master.key
	cp ../../.env.example ../../.env
	docker-compose build
	docker-compose run web yarn install
	docker-compose run web bundle exec rails db:drop
	docker-compose run web bundle exec rails db:prepare
	@echo "The installation was successful."
	@echo "Run 'make up' or 'docker-compose up' to get started."
bundle:
	docker-compose run web /bin/bash -c "bundle check || bundle install"
yarn-install:
	docker-compose run web yarn install
console:
	docker-compose exec web bundle exec rails console
seed:
	docker-compose exec web bundle exec rails db:seed
migrate:
	docker-compose run web bundle exec rails db:migrate
up:
	docker-compose up
down:
	docker-compose down
start:
	docker-compose start
stop:
	docker-compose stop
attach_web:
	docker attach diverse-web-development
attach_sidekiq:
	docker attach diverse-sidekiq-development
lints:
	docker-compose run web make lints
