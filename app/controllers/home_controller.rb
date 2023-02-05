class HomeController < ApplicationController
  def index
    render plain: "twilio-rails-example"
  end
end
