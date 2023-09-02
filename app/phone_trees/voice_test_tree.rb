# frozen_string_literal: true
class VoiceTestTree < Twilio::Rails::Phone::BaseTree
  voice "Polly.Joanna-Neural"
  # final_timeout_message("Goodbye.")
  # invalid_phone_number("Sorry, we cannot accept your call.")

  greeting message: "Hello! You have reached the call centre for the most powerful AI ever created. I appreciate you taking the time to phone today! So now...",
    prompt: :say_something

  prompt :say_something,
    message: "I am listening to you. Please describe what you would like to hear from me.",
    gather: {
      type: :speech,
      language: "en-US",
      enhanced: true,
      speech_model: "phone_call",
      # speech_timeout: "auto",
      speech_timeout: 2,
    },
    after: :thinking

  prompt :thinking,
    message: ->(response) {
      if macros.last_transcription(response).blank?
        "I am sorry, I did not hear you say anything."
      else
        [
          THINKING.sample,
          macros.pause(2),
        ]
      end
    },
    after: ->(response) {
      if macros.last_transcription(response).blank?
        :say_something
      else
        if macros.last_transcription_answer(response).blank?
          :thinking
        else
          :read_answer
        end
      end
    }

  prompt :read_answer,
    message: ->(response) {
      macros.last_transcription_answer(response)
    },
    after: {
      message: [
        macros.pause(1),
        "I hope that was enlightening.",
      ],
      prompt: :again_or_goodbye,
    }

  prompt :again_or_goodbye,
    message: "Would you like to go again?",
    gather: {
      type: :speech,
      language: "en-US",
      enhanced: true,
      speech_model: "numbers_and_commands",
      speech_timeout: "auto",
    },
    after: ->(response) {
      if response.answer_yes? || response.transcription_matches?(AGAIN)
        :say_something
      else
        {
          message: "Thank you. Have a good day.",
          hangup: true,
        }
      end
    }


  THINKING = [
    "Hmm...",
    "Well...",
    "Let me think...",
    "Oh that's a tough one...",
    "Hmmmmmm",
    "Hmm",
    "Uhhh",
    "Uhhhhhh",
    "Hmm"
  ].freeze

  AGAIN = [
    "again",
    "more",
    "please",
  ].freeze
end
