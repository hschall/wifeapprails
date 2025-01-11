class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :records

  # Role definitions
  ROLES = %w[user admin]

  # Validations
  validates :role, inclusion: { in: ROLES }

  # Callbacks
  before_create :set_default_role

  # Methods
  def admin?
    role == "admin"
  end

  def user?
    role == "user"
  end

  private

  def set_default_role
    self.role ||= "user"
  end
end

