require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /" do
    it "returns http success and a string" do
      get "/"
      expect(response).to have_http_status(:success)
      expect(response.body).to include("twilio-rails-example")
    end
  end
end
