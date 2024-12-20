class Course < ApplicationRecord
  include PublicActivity::Model
  tracked

  # Validations
  validates :title, :short_description, :price, :languaes, :level, presence: true
  validates :description, presence: true, length: { minimum: 5 }
  validates :image_url, allow_blank: true, format: { with: URI::regexp(%w[http https]), message: "must be a valid URL" }

  # Associations
  has_rich_text :description
  belongs_to :user, counter_cache: true
  has_many :lessons, dependent: :destroy
  has_many :enrollments, dependent: :restrict_with_error
  has_many :user_lessons, through: :lessons
  has_one_attached :avatar

  # Scopes
  scope :latest, -> { limit(3).order(created_at: :desc) }
  scope :top_rated, -> { limit(3).order(average_rating: :desc, created_at: :desc) }
  scope :popular, -> { limit(3).order(enrollments_count: :desc, created_at: :desc) }

  # Methods
  def to_s
    title
  end

  def self.ransackable_attributes(auth_object = nil)
    ["title", "short_description", "languaes", "level", "price", "created_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end

  def bought(user)
    self.enrollments.where(user_id: user.id, course_id: self.id).empty?
  end

  def progress(user)
    unless self.lessons_count == 0
      user_lessons.where(user: user).count / self.lessons_count.to_f * 100
    end
  end

  def update_rating
    if enrollments.any? && enrollments.where.not(rating: nil).any?
      update_column :average_rating, (enrollments.average(:rating).round(2).to_f)
    else
      update_column :average_rating, 0
    end
  end
end
