# Desk1 Datamart. Trade with confidence

## Dev

### Env Setup

1. Make sure you have an env folder at the top level of the structure
2. Inside of this folder, create a .env-local and a .env-prod env file.
3. Create a .env-template file that is going to be filled in when sourcing.
4. Source whichever environment you are working with.
5. source .env-local for example
6. envsubst your .env-template into a env.
7. cd back to top level
8. Run make-deploy
