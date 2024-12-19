class Course < ApplicationRecord
    include PublicActivity::Model
    tracked
    # Validations
    validates :title, :short_description, :price, :languaes, :level, presence: true
    validates :description, presence: true, length: { minimum: 5 }

    belongs_to :user, counter_cache: true
    has_many :lessons, dependent: :destroy
    has_rich_text :description
    has_many :enrollments


    scope :latest, -> { limit(3).order(created_at: :desc) }
    scope :top_rated, -> { limit(3).order(average_rating: :desc, created_at: :desc) }
    scope :popular, -> { limit(3).order(enrollments_count: :desc, created_at: :desc) }

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
      self.enrollments.where(user_id: [user.id], course_id: [self.id]).empty?
    end

    def update_rating
      if enrollments.any? && enrollments.where.not(rating: nil).any?
        update_column :average_rating, (enrollments.average(:rating).round(2).to_f)
      else
        update_column :average_rating, (0)
      end
    end

  end
  