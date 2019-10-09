# Loany

_Elixir Developer Coding Exercise: Dmitry Vysotsky_

## Assumptions

On this iteration we don't provide the user account, but admin account for check applications. But in the future anyway we'll want to have an account for customer. So I decide to create User model and bind all loan applications to this model and use an email as personal key. Hence we have the next question.

Should we allow to customer to apply with different phone number, email or name every time? Assumption - not. On this iteration it's overengineering.

Type for mnesia is set, not bulb, because of we could have potentialy the same rows with the same amount and rate

Add service for unevaluated applications check

## Setup

Fetch dependencies.

```sh
mix deps.get
```

Create DB and run migrations.

```sh
mix ecto.create && mix ecto.migrate
```

Run seeds(with a admin user for applications list check).

```sh
mix run priv/repo/seeds.exs
```

Prepare Mnesia DB(for loan rates store).

```sh
mix loany.setup
```

And run project.

```sh
iex -S mix phx.server
```
