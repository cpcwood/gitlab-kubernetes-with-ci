# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    render json: { hello: 'world' }
  end
end
