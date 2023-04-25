# diverse

## Features

Clone this repo and then open this project into your code editor

```
$ git clone git@github.com:woodpecker-jp/diverse.git
```

以下、ブランチ「develop」で実行する。

## Installation

### For development

Install docker and docker-compose latest version first.

Init development environment
```
$ cd deployments/development # docker work directory
$ make init
```

Start server

```
$ make up
```

Endpoint

```
Employee
http://localhost:3000

Medical
http://localhost:3000/medical

Admin
http://localhost:3000/admin (default account: super_admin@diverse-work.com | 123456)
```

Mail box:

```
http://localhost:3000/letter_opener
```

Background Job Service

```
http://localhost:3000/sidekiq
```

## Development commands


### Migrate

```
$ make migrate
```

### Lints

```
$ make lints
```
# diverse
# diverse
# diverse
# diverse
# diverse
