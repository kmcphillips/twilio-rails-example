# frozen_string_literal: true
class CountResponder < Twilio::Rails::SMS::DelegatedResponder
  def handle?
    # Every message that has not yet been handled, in this case by the `InfoResponder` is handled here.
    # If no handlers return true, the message is ignored.
    true
  end

  def reply
    call_count_string = case phone_caller.phone_calls.count
    when 0
      "You have never called before. Please give us a call!"
    when 1
      "You have called once before."
    else
      "You have called #{ call_count } times before."
    end

    "This is the example app for the `twilio-rails` gem. #{ call_count_string }"
  end
end
