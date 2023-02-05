class HomeController < ApplicationController
  def index
    render plain: "<a href='https://github.com/kmcphillips/twilio-rails-example'>https://github.com/kmcphillips/twilio-rails-example</a>"
  end
end
