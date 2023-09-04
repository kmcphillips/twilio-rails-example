# frozen_string_literal: true
class LinkResponder < Twilio::Rails::SMS::DelegatedResponder
  def handle?
     # This helper method is defined on the base class and accepts strings or regexes and compares agains the message body.
     # This is equivalent to returning `body.downcase.include?("link") || etc.`
    matches?("link") || matches?("github") || matches?("code") || matches?("url")
  end

  def reply
    "This is the example app for the `twilio-rails` gem. https://github.com/kmcphillips/twilio-rails-example"
  end
end
