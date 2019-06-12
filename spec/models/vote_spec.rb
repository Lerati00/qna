require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }
  it { should belong_to :votable }

  it { should validate_presence_of :votable }
  
  subject { create(:vote, :for_question) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:votable_type, :votable_id) }
end
