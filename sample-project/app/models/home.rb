# frozen_string_literal: true

class Home < ApplicationRecord
  validates :name, presence: true
end
