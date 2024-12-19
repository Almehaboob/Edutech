class Lesson < ApplicationRecord

  belongs_to :course, counter_cache: true
  #Course.find_each { |course| Course.reset_counters(course.id, :lessons) }  
  has_many :user_lessons
  
  validates :title, :content, :course, presence: true
  
  include PublicActivity::Model
  tracked owner: Proc.new { |_controller, model| model.owner }
  attr_accessor :owner # Allows explicit assignment of the owner

  has_rich_text :content

  def viewed(user)
    self.user_lessons.where(user: user).present?
    #self.user_lessons.where(user_id: [user.id], lesson_id: [self.id]).empty?
  end


  def to_s
    title
  end
end
