`get-env.sh` is a script that will get the value of a custom field labeled ".env" from a 1Password item.

`sync-env.sh` is an example script that will sync a specific 1Password item to a .env file.

The idea is that `get-env.sh` would be placed somewhere globally accessible, and then `sync-env.sh` would be placed in a project directory and run as part of a build process or manually to sync the .env from 1Password.

Requires having the environment variable `OP_SERVICE_ACCOUNT_TOKEN` set to a valid 1Password service account token.
