# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Home, type: :model do
  subject(:home) { Home.new(name: 'test') }

  describe '#name' do
    describe 'validations' do
      it 'presence' do
        home.name = nil
        expect(home).to_not be_valid

        home.name = 'test'
        expect(home).to be_valid
      end
    end
  end
end
