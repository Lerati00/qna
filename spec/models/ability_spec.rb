require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all}

  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user 'do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, author: user, answers: create_list(:answer, 1))}
    let(:other_question) { create(:question, author: other_user, answers: create_list(:answer, 1))}
    let(:answer) { create(:answer, author: user)}
    let(:other_answer) { create(:answer, author: other_user)}

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_question }
    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, other_answer }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, other_question }
    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, other_answer }

    it { should be_able_to :best, question.answers.first } 
    it { should_not be_able_to :best, other_question.answers.first }

    it { should be_able_to :destroy, create(:link, linkable: question) }
    it { should_not be_able_to :destroy, create(:link, linkable: other_question) }
    it { should be_able_to :destroy, create(:link, linkable: answer) }
    it { should_not be_able_to :destroy, create(:link, linkable: other_answer) }

    it { should be_able_to %i[vote_up vote_down vote_cancel], other_answer }
    it { should_not be_able_to %i[vote_up vote_down vote_cancel], answer }
    it { should be_able_to %i[vote_up vote_down vote_cancel], other_question }
    it { should_not be_able_to %i[vote_up vote_down vote_cancel], question }
  end
end