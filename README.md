# Desk1 Datamart. Trade with confidence

## User

### What is Desk1 Datamart?

Datamart is a stateless API serving [Desk1 Trading](https://deskonetrading.com). It is currently under development.

## Dev

### Env Setup

#### First Time Set up

1. Create an env folder at root level.
2. Inside of this folder, create a .env-local .env-prod and a .env-template file.
   a. The .env-template file will be used for envsubst later on
   b. Add variables like ENV=$ENV into the .env-template file. These will be filled

#### Running

1. Export your env variables in whichever env you are in by sourcing the respective file.
2. run `envsubst < .env-template > .env` to substitute the recently sourced variables into the .env file
3. cd back to top level
4. Run make-deploy
