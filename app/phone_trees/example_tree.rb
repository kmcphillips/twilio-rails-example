# frozen_string_literal: true
class ExampleTree < Twilio::Rails::Phone::BaseTree
  voice "Polly.Matthew-Neural"

  final_timeout_message "Sorry, we have not received any input for a while. Goodbye."

  # The `twilio-rails` library was extracted from a project that only needed to accept phone calls from North American phone numbers. It's a serious limitation I now regret, but I'll try to remove it in future.
  invalid_phone_number "Thank you for your call. Unfortunately, the twilio rails gem is currently limited to accepting phone calls from North American phone numbers only. We know this is unfair, but we are accepting pull requests and will get better in the future. Thank you and goodbye for now."

  # This is triggered a number of ways, and is managed by Twilio and the framework. It will fire in most cases when the phone call has been completed by either party.
  finished_call ->(phone_call) {
    # This trigger is already called in a job, but it is best to do something simple like enqueue another job to do the work. But this is an example so we will do it inline.
    Twilio::Rails::SMS::SendOperation.call(
      phone_caller_id: phone_call.phone_caller.id,
      messages: [ "Thank you for calling today. You can view the app source code here: https://github.com/kmcphillips/twilio-rails-example" ],
      from_number: phone_call.number
    )
  }

  # This is the entrypoint. All incoming or outgoing calls enter here first.
  greeting message: "Hello!", # `message:` here is optional
    prompt: :check_if_name_present

  # In fact `message:` is always optional, but every prompt will add a `Response` record in the DB.
  prompt :check_if_name_present,
    after: ->(response) {
      if response.phone_caller.name.present?
        :greet_by_name
      else
        :ask_for_name
      end
    }

  prompt :ask_for_name,
    message: "Thank you for your call today. To start out, can you please tell us your name or the name you would like to be called? Please say your name or say, 'no', to remain anonymous, now:",
    gather: {
      type: :speech, # `:speech` is done in realtime but does not provide a recording.
      language: "en-US",
      enhanced: true,
      speech_model: "phone_call",
      speech_timeout: 2,
    },
    after: ->(response) {
      if response.transcription.present?
        if macros.answer_no?(response.transcription) || response.transcription.downcase.include?("anonymous")
          # It's best to do this kind of thing in business object operations, or async jobs if they are big and retryable. But for the sake of example we can do whatever we want in these procs.
          response.phone_caller.update!(name: macros.generate_random_name)

          {
            message: "We fully respect your desire to remain anonymous. Instead we will invent a name and call you... #{ response.phone_caller.name }. So #{ response.phone_caller.name }, how can we help you today?",
            prompt: :main_menu,
          }
        else
          # Again, do this in another place in a real production app.
          response.phone_caller.update!(name: response.transcription)

          {
            message: "Perfect. It is good to meet you #{ response.phone_caller.name }. So, how can we help you today?",
            prompt: :main_menu,
          }
        end
      else
        # Remember that `#generate_random_name` is defined in `lib/example_phone_macros.rb` and automatically made available here by the `include_phone_macros` call in the initializer.
        response.phone_caller.update!(name: macros.generate_random_name)

        {
          message: "We did not hear you say your name. That's ok. You can keep your secret name. Instead we will make up a name and call you... #{ response.phone_caller.name }. So #{ response.phone_caller.name }, how can we help you today?",
          prompt: :main_menu,
        }
      end
    }

  prompt :greet_by_name,
    message: ->(response) {
      "It is so good to hear from you again #{ response.phone_caller.name }! How can we help you today?"
    },
    after: :main_menu

  # Lots of fun things you can do. These are toy examples, but you can make API calls, fetch database records, or really anything you want. You have access to the phone caller and any of their associated history, so you can
  # retrieve the history of their calls or any records associated with them.
  MAIN_MENU_CHOICES = [
    "say the current time",
    "do some math",
    "end this call and hang up",
  ].freeze

  prompt :main_menu,
    message: "Main menu. #{ macros.numbered_choices(MAIN_MENU_CHOICES, prefix: "To") }",
    gather: macros.digit_gather_interruptable, # This is a helper method defined in `Twilio::Rails::Phone::TreeMacros` and is part of the library. It is the same as `{ type: :digits, timeout: 6, number: 1, interrupt: true }`.
    after: ->(response) {
      # These helpers are defined in `Twilio::Rails::Phone::TreeMacros` and are part of the library. But they are convenience functions and replace manually writing out and checking for all these conditions.
      if macros.numbered_choice_response_includes?(MAIN_MENU_CHOICES, response: response)
        if response.digits == "1"
          :say_current_time
        elsif response.digits == "2"
          :do_some_math
        elsif response.digits == "3"
          :end_call
        else
          raise "This should never be reached. #{ response }"
        end
      else
        {
          message: "Please use your touch tone phone to enter a valid selection.",
          prompt: :main_menu,
        }
      end
    }

  prompt :say_current_time,
    message: ->(response) {
      "Thank you for your interest in clocks. These servers are running in the beautiful city of Montreal, where the current time is, #{ Time.use_zone("America/Montreal") { Time.zone.now.strftime("%l:%M %p").strip } }. That's probably my favourite time of day."
    },
    after: :main_menu

  prompt :do_some_math,
    message: "Alright, we are going to offer you some compute time on our servers to do some advanced math together.",
    after: :gather_first_digit

  prompt :gather_first_digit,
    message: "Using the keypad on your Touchtone phone, please enter a two digit number.",
    gather: {
      type: :digits,
      timeout: 5, # seconds before timing out and running the `after:`
      number: 2,
      interrupt: true, # this means the user can start pressing keys while speech is speaking.
    },
    after: ->(response) {
      if response.digits.present? && response.digits.match?(/\A[0-9][0-9]\Z/) # could also be just: `if response.integer_digits`
        {
          message: "Thank you. You entered #{ response.integer_digits }.", # This returns an integer when digits are entered, or nil in all other cases.
          prompt: :gather_second_digit,
        }
      else
        {
          message: "Sorry, we did not receive a valid two digit number.",
          prompt: :gather_first_digit,
        }
      end
    }

  prompt :gather_second_digit,
    message: "Now please enter a second two digit number.",
    gather: {
      type: :digits,
      timeout: 5,
      number: 2,
      interrupt: true, # this means the user can start pressing keys while speech is speaking.
    },
    after: ->(response) {
      if response.digits.present? && response.digits.match?(/\A[0-9][0-9]\Z/)
        {
          message: "Perfect. You entered #{ response.integer_digits }.",
          prompt: :doing_math,
        }
      else
        {
          message: "Sorry, we did not receive a valid two digit number.",
          prompt: :gather_second_digit,
        }
      end
    }

  prompt :doing_math,
    # Any values here that are not procs are evaluated at application load time.
    # The `message:` can be an array which is useful for mixing speech synthesis and audio file playback or pauses.
    message: [
      "Ok, we are going to do some math with the numbers you entered.",
      macros.play_public_file("processing.mp3"), # This is a helper method defined in `Twilio::Rails::Phone::TreeMacros` and is part of the library.
                                                 # It is the same as `{ play: public_file("processing.mp3") }` or `{ play: "https://example.com/processing.mp3" }`.
      macros.pause, # This is a helper method defined in `Twilio::Rails::Phone::TreeMacros` and is the same as `{ pause: 1 }` meaning one second.
    ],
    after: :math_result

  prompt :math_result,
    message: ->(response) {
      # Here we want to grab the two valid responses from the `gather_first_digit` and `gather_second_digit` prompts and add them together.
      # We have access to all responses on the phone call and can scope them using the provided scopes.
      first_digit = response.phone_call.responses.in_order.prompt(:gather_first_digit).last.integer_digits
      second_digit = response.phone_call.responses.in_order.prompt(:gather_second_digit).last.integer_digits

      [
        "The result of adding together, #{ first_digit }, plus, #{ second_digit }, is",
        macros.pause(1),
        "#{ first_digit + second_digit }.",
        macros.pause(1),
        "We hope this math was helpful for you.",
      ]
    },
    after: :main_menu

  prompt :end_call,
    message: ->(response) {
      "Thank you for your call today #{ response.phone_caller.name }. Please call back anytime. Goodbye."
    },
    after: { hangup: true } # This special case is the only explicit way to end the call from the server side.

end
