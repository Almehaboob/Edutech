class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable   

  def to_s 
    email
  end

  has_many :courses, dependent: :nullify
  has_many :enrollments,  dependent: :nullify
  has_many :user_lessons, dependent: :nullify

  
  # Allowable searchable attributes for Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["email", "sign_in_count", "created_at", "current_sign_in_at", "current_sign_in_ip", "last_sign_in_at", "last_sign_in_ip"]
  end

  # Allowable searchable associations for Ransack
  def self.ransackable_associations(auth_object = nil)
    ["courses"]
  end
  
  after_create :assign_default_role

  def assign_default_role
    if User.count==1
      self.add_role(:admin) if self.roles.blank?
      self.add_role(:teacher)
      self.add_role(:student)
    else
      self.add_role(:student) if self.roles.blank?
      self.add_role(:teacher)
    end

  end
  
  def online?
    updated_at > 2.minutes.ago
  end
  def buy_course(course)
    self.enrollments.create(course: course, price: course.price)
  end
  def view_lesson(lesson)
    unless self.user_lessons.where(lesson: lesson).any?
      self.user_lessons.create(lesson: lesson)
    end
  end

  validate :must_have_a_role, on: :update
  private


  def must_have_a_role
    unless roles.any?
      errors.add(:roles, "must have at least one role")
    end
  end

end
