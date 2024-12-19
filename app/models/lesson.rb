class Lesson < ApplicationRecord

  belongs_to :course, counter_cache: true
  #Course.find_each { |course| Course.reset_counters(course.id, :lessons) }  

  
  validates :title, :content, :course, presence: true
  
  include PublicActivity::Model
  tracked owner: Proc.new { |_controller, model| model.owner }
  attr_accessor :owner # Allows explicit assignment of the owner

  has_rich_text :content


  def to_s
    title
  end
end
