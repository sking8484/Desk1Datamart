# Desk1 Datamart. Trade with confidence

## User

### What is Desk1 Datamart?

Datamart is a stateless API serving [Desk1 Trading](https://deskonetrading.com). It is currently under development.

## Dev

### Env Setup

#### First Time Set up

1. Create an env folder at root level.
2. Inside of this folder, create a .env-local .env-prod and a .env-template file.
   1. The .env-template file will be used for envsubst later on
   2. Add variables like ENV=$ENV into the .env-template file. These will be filled
3. Update the .env-local, .env-prod and the .env-template file with what your respective variables.
4. The resulting .env file will be env/.env. Point your code to that file.

#### Running

1. At top level, to prepare for a local or production, run `make build-env-local` or `make build-env-prod`
2. Run make-deploy
