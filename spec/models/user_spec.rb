require 'rails_helper'

RSpec.describe User, type: :model do
  it {should have_many(:questions).with_foreign_key('author_id').inverse_of(:author)}
end
