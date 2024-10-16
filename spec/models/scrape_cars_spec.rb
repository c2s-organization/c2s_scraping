require 'rails_helper'

RSpec.describe ScrapeCar, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:task_id) }
    it { should validate_presence_of(:url) }
  end
end
