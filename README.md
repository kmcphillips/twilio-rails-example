# Twilio Rails Example

This is an example app to demonstrate a the [`twilio-rails`](https://github.com/kmcphillips/twilio-rails) gem.

You can interact with a deployed version of this app by calling:
* In Canada: TODO
* In the US: TODO


## What is this?

This example app is split into commits intended to show how to build a Rails app to manage interactive phone calls using Twilio and the `twilio-rails` gem. The commits are:

* Initialize a basic Rails 7 app on Ruby 3.2.0. `rails new twilio-rails-example --database=sqlite3 --api --pretend`
* Deploy the app. I am using [`fly.io`](https://fly.io) with Docker, but it doesn't really matter.
* Add the `twilio-rails` gem to the app, then run `bin/rails generate twilio_rails:install` to install the initializer, models, migrations, and routes.
* Run the `bin/rails generate twilio_rails:phone_tree example` generator to create the example phone tree. Then add functionality to the phone tree.


## Running this app

You can interact with this deployed app by calling the phone numbers at the top. But you can also run it on your own.

Clone this repo and run `bundle install` to install the dependencies.

The `Dockerfile` may mostly work as is, but is actually the production configuration for deploying this app. Currently it is deployed on [Fly.io](https://fly.io).

### Environment variables

This app depends on the following environment variables to be deployed in production:

* `DATABASE_URL`: This example is using `mysql2` as the database, but you can use any database supported by Rails.
* `REDIS_URL`: Redis is used for `sidekiq` as the ActiveJob backend.
* `AWS_ACCESS_KEY_ID`: AWS S3 used in `storage.yml` to store audio recording files. Any ActiveStorage provider will work.
* `AWS_SECRET_ACCESS_KEY`: AWS S3 used in `storage.yml` to store audio recording files. Any ActiveStorage provider will work.
* `AWS_BUCKET`: AWS S3 used in `storage.yml` to store audio recording files. Any ActiveStorage provider will work.


## Local development

Twilio requires a publicly accessible URL to make requests to. When developing locally a tool such as [ngrok](https://ngrok.com/) can expose a local dev server via a publicly available SSL URL. Ngrok has a free tier and is easy to use. [See the install instructions for more information](https://ngrok.com/download). Other forwarding services exist and will work fine as well.

Once the forwarding service is configured, the publicly facing URL must be entered into both the initializer, or in this case the environment variable, as well as the Twilio dashboard.

TODO


## Developing `twilio-rails`

To test changes to [`twilio-rails`](https://github.com/kmcphillips/twilio-rails), clone the repo or the fork and update the `Gemfile` in this app:

```ruby
gem 'twilio-rails', path: '../twilio-rails'
```

Then run `bundle install`. This will use the local version of the gem instead of the one on RubyGems.


## Contributing

Please feel free to open issues or PRs! I will help you make improvements to this app and the gem.
