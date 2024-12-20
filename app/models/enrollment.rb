class Enrollment < ApplicationRecord
  belongs_to :course, counter_cache: true
  belongs_to :user, counter_cache: true
  #User.find_each { |user| User.reset_counters(user.id, :enrollments) }  
  validates :user, :course, presence: true

  validates_presence_of :rating, if: :review?
  validates_presence_of :review, if: :rating?

  validates_uniqueness_of :user_id, scope: :course_id  # User can't be subscribed to the same course twice
  validates_uniqueness_of :course_id, scope: :user_id  # User can't be subscribed to the same course twice

  validate :cant_subscribe_to_own_course  # User can't create a subscription if course.user == current_user.id

  scope :pending_review, -> { where(rating: [0, nil, ""], review: [0, nil, ""]) }
  scope :reviewed, -> { where.not(review: [0, nil, ""]) }
  scope :latest_good_reviews, -> { order(rating: :desc, created_at: :desc).limit(3) }

  
  # Define ransackable attributes
  def self.ransackable_attributes(auth_object = nil)
    ["id", "course_id", "created_at", "price", "rating", "review", "updated_at", "user_id"]
  end

  # Define ransackable associations
  def self.ransackable_associations(auth_object = nil)
    ["user", "course"]
  end

  def to_s
    user.to_s + " " + course.to_s
  end

  after_save do
    unless rating.nil? || rating.zero?
      course.update_rating
    end

  end

  after_destroy do

    course.update_rating
  end

  protected

  def cant_subscribe_to_own_course
    if new_record? && user_id.present? && user_id == course.user_id
      errors.add(:base, "You can not subscribe to your own course")
    end
  end
end
