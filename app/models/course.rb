class Course < ApplicationRecord
    # Validations
    validates :title, :short_description, :price, :languaes, :level, presence: true
    validates :description, presence: true, length: { minimum: 5 }
  
    # Associations
    belongs_to :user
    has_rich_text :description
  
    # Display Title
    def to_s
      title
    end
  
    # Ransack Configuration
    def self.ransackable_attributes(auth_object = nil)
      ["title", "short_description", "languaes", "level", "price", "created_at"]
    end
  
    def self.ransackable_associations(auth_object = nil)
      ["user"]
    end
  end
  