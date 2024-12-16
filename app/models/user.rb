class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable   

  def to_s 
    email
  end

  has_many :courses
  
  # Allowable searchable attributes for Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["email", "sign_in_count", "created_at", "current_sign_in_at", "current_sign_in_ip", "last_sign_in_at", "last_sign_in_ip"]
  end

  # Allowable searchable associations for Ransack
  def self.ransackable_associations(auth_object = nil)
    ["courses"]
  end
end
