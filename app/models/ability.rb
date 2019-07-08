# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    # Define abilities for the passed in user here. For example:
    #
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can %i[update destroy], [Question, Answer], { author_id: user.id }
    can :best, Answer, question: { author_id: user.id }

    can :destroy, [Link] do |object|
      object.linkable.author_id == user.id
    end

    can %i[vote_up vote_down vote_cancel], [Answer, Question] do |object|
      !user.author_of?(object)
    end
  end

  def admin_abilities
    can :manage, :all
  end
end
