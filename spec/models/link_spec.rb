require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe '#validates_url_format' do
    it 'checks the validity of the link' do
      expect { create(:link, :for_question) }.to change(Link, :count).by(1)
    end

    it 'returns false if url is invalid' do
      expect { create(:link, :for_question, :with_invalid_url) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
