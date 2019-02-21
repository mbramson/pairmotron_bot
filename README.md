# PairmotronBot

A Slack Bot which pairs users together on demand.

# Installation

- Make sure postgres is installed and set the following environment variables:
  - `PG_USER` - name of postgres user that can create tables
  - `PG_PASSWORD` - password for that postgres user
- Get a Bot User OAuth Access Token. See https://api.slack.com/bot-users for
  details on how to get this.
  - Set the `SLACK_PAIRMOTRON_BOT_USER_ACCESS_TOKEN` environment variable to
    this API key.
- Fetch elixir dependencies
  - `mix deps.get`
- Create and migrate the database
  - `mix ecto.setup`
- Install javascript dependencies
  - `cd assets && npm install`

# Usage

This is also a phoenix server. Start with:
```
mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

If everything is wired up properly you should see `"Successfully connected to
Slack as <Your bot name>"` in the console.
