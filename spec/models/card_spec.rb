require 'rails_helper'

RSpec.describe Card, type: :model do
  # Association test
  it { should belong_to(:list) }
  it { should belong_to(:created_by) }
  # Validation test
  it { should validate_presence_of(:title) }
end
