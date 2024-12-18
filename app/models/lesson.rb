class Lesson < ApplicationRecord

  belongs_to :course
  validates :title, :content, :course, presence: true
  
  include PublicActivity::Model
  tracked owner: Proc.new { |_controller, model| model.owner }
  attr_accessor :owner # Allows explicit assignment of the owner

  has_rich_text :content


  def to_s
    title
  end
end
