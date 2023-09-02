class AiCallJob < ApplicationJob
  queue_as :default

  def perform(response_id:)
    response = Response.find(response_id)
    parameters = {
      prompt: response.transcription,
      model: "davinci-instruct-beta-v3",
      max_tokens: 100,
      temperature: 0.8,
      top_p: 1.0,
      frequency_penalty: 0.6,
      presence_penalty: 0.1,
    }

    client = OpenAI::Client.new(access_token: "TODO")
    open_ai_response = client.completions(parameters: parameters)

    if open_ai_response.success?
      result = open_ai_response["choices"][0]["text"].strip
      response.update(answer: result)
    else
      raise "OpenAI request was not successful #{ open_ai_response }"
    end
  end
end
