# AppPlanB

Web application for Plan B system that allows create secret note to share with people when we will die

Please also note the Web API that it uses: https://github.com/CaciquesProgramadores/PlanB

## Install

Install this application by cloning the *relevant branch* and use bundler to install specified gems from `Gemfile.lock`:

```shell
bundle install
```

## Test

This web app does not contain any tests yet :(

## Execute

Launch the application using:

```shell
rake run:dev
```

The application expects the API application to also be running (see `config/app.yml` for specifying its URL)
