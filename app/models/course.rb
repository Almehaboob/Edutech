class Course < ApplicationRecord
    include PublicActivity::Model
    tracked
    # Validations
    validates :title, :short_description, :price, :languaes, :level, presence: true
    validates :description, presence: true, length: { minimum: 5 }

    belongs_to :user
    has_many :lessons, dependent: :destroy
    has_rich_text :description
    has_many :enrollments

    def to_s
      title
    end
  
  
    def self.ransackable_attributes(auth_object = nil)
      ["title", "short_description", "languaes", "level", "price", "created_at"]
    end
  
    def self.ransackable_associations(auth_object = nil)
      ["user"]
    end


  end
  