# Twilio Rails Example

This is an example app to demonstrate a the [`twilio-rails`](https://github.com/kmcphillips/twilio-rails) gem.

You can interact with a deployed version of this app by calling:
* **Calling from Canada:** 📞 (204) 800-7772
* **Calling from the US:** 📞 (631) 800-7772
* **Internationally:** [Sorry, not yet supported](https://github.com/kmcphillips/twilio-rails#limitations-and-known-issues)


# What is `twilio-rails`?

You can view the [documentation and README for `twilio-rails`](https://github.com/kmcphillips/twilio-rails) in the repo. The it is a gem, an opinionated Rails engine, and a framework for building complex, realtime, stateful phone interactions in Rails without needing to directly interact with the Twilio API or use TwiML.


## What is this?

This example app is split into commits intended to show how to build a Rails app to manage interactive phone calls using Twilio and the `twilio-rails` gem.

The commits are cleanly split as follows:

* [57dc7cf9](https://github.com/kmcphillips/twilio-rails-example/commit/57dc7cf9cd7f861f0d2ee81ab31ffc35e488f843): Initialize a basic Rails 7 app on Ruby 3.2.2. `rails new twilio-rails-example --database=sqlite3 --skip-test`
* [7b8f6f1e](https://github.com/kmcphillips/twilio-rails-example/commit/7b8f6f1e64fbaf0634fae56695b84bf677c44ff0): Configure for production and deploy the app. I am using [`fly.io`](https://fly.io) with Docker, but it doesn't really matter.
* [3673fd02](https://github.com/kmcphillips/twilio-rails-example/commit/3673fd027e93565733b6f0fb4c8573e35a51c876): Add the `twilio-rails` gem to the app, then run `bin/rails generate twilio_rails:install` to install the initializer, models, migrations, and routes.
* [257e9891](https://github.com/kmcphillips/twilio-rails-example/commit/257e9891afb6c98e7b409751b5898a9140d632a8): Run the `bin/rails generate twilio_rails:phone_tree example` generator to create the example phone tree. Then add functionality to the phone tree.
* [019349f8](https://github.com/kmcphillips/twilio-rails-example/commit/019349f88e3a26c8fbe23abea491a89ea749c153): Run the `bin/rails generate twilio_rails:sms_responder example` generator to create the example SMS responder. Then add functionality to the SMS responder.


## Running this app

You can interact with this deployed app by calling the phone numbers at the top. But you can also run it on your own.

Clone this repo and run `bundle install` to install the dependencies.

The `Dockerfile` may mostly work as is, but is actually the production configuration for deploying this app. Currently it is deployed on [Fly.io](https://fly.io).


### Environment variables

This app depends on the following environment variables to be deployed in production, or [configured in the `.env` file](https://github.com/bkeepers/dotenv):

* `DATABASE_URL`: This example is using `mysql2` as the database, but you can use any database supported by Rails.
* `REDIS_URL`: Redis is used for `sidekiq` as the ActiveJob backend.
* `TWILIO_RAILS_EXAMPLE_HOST`: The domain name where the app is running, such as `"my-app.ngrok.io"`. See local development section below.
* `TWILIO_RAILS_EXAMPLE_PHONE_NUMBER`: The phone number purchased from the Twilio dashboard that will be used to make outgoing phone calls and send SMS messages, formatted as `"+16135550000"`.
* `TWILIO_ACCOUNT_SID`: The Twilio account SID found in the Twilio dashboard.
* `TWILIO_AUTH_TOKEN`: The Twilio auth token found in the Twilio dashboard.
* `AWS_ACCESS_KEY_ID`: AWS S3 used in `storage.yml` to store audio recording files. Any ActiveStorage provider will work.
* `AWS_SECRET_ACCESS_KEY`: AWS S3 used in `storage.yml` to store audio recording files. Any ActiveStorage provider will work.
* `AWS_BUCKET`: AWS S3 used in `storage.yml` to store audio recording files. Any ActiveStorage provider will work.


## Local development

Twilio requires a publicly accessible URL to make requests to. When developing locally a tool such as [ngrok](https://ngrok.com/) can expose a local dev server via a publicly available SSL URL. Ngrok has a free tier and is easy to use. [See the install instructions for more information](https://ngrok.com/download). Other forwarding services exist and will work fine as well.

Once the forwarding service is configured, the publicly facing URL must be set as the `TWILIO_RAILS_EXAMPLE_HOST` environment variable.

Finally, some URLs at those hosts must be configured in the Twilio dashboard. Info on how to do this with the correct values can be found by running:

```sh
bin/rails twilio:rails:config
```


## Developing `twilio-rails`

To test changes to [`twilio-rails`](https://github.com/kmcphillips/twilio-rails), clone the repo or the fork and update the `Gemfile` in this app:

```ruby
# locally
gem 'twilio-rails', path: '../twilio-rails'

# forked on Github
gem "twilio-rails", github: "you-fabulous-open-source-developer/twilio-rails", branch: "your-incredible-feature-branch"
```

Then run `bundle install`. This will use the local version of the gem instead of the one on RubyGems.


## Contributing

Please feel free to open issues or PRs. I will help you make improvements to this app and the gem. But it is best to start [by contributing to the gem or opening an issue there](https://github.com/kmcphillips/twilio-rails#contributing).
