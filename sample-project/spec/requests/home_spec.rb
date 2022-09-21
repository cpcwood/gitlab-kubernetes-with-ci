# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  describe 'GET /index' do
    it 'returns json response' do
      get '/'

      expect(response.body).to eq({ hello: 'world' }.to_json)
    end
  end
end
