class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: %i[github facebook]

  has_many :questions, foreign_key: 'author_id', inverse_of: :author
  has_many :answers,   foreign_key: 'author_id', inverse_of: :author
  has_many :rewards
  has_many :authorizations, dependent: :destroy

  has_many :subscriptions, dependent: :destroy
  has_many :subscibed_on_questions, through: :subscriptions,
           source: :subscribable, source_type: 'Question'

  def author_of?(resource)
    id == resource.author_id
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
