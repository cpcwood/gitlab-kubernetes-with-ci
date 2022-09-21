# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index', defaults: { format: :json }
end
