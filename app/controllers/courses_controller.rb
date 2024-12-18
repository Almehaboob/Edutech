class CoursesController < ApplicationController
  include Pagy::Backend  # Include Pagy for pagination

  before_action :set_course, only: %i[ show edit update destroy ]

  def index
    @q = Course.ransack(params[:q])
    @pagy, @courses = pagy(@q.result(distinct: true))  # Pagy pagination
  end

 
  def show
    @lessons = @course.lessons
    puts @lessons.inspect 
  end

  
  def new
    
    @course = Course.new
    authorize @course
  end

  
  def edit
    authorize @course
  end


  def create
    
    @course = Course.new(course_params)
    @course.user=current_user
    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
    authorize @course
  end

  def update
    authorize @course
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    authorize @course
    @course.destroy!

    respond_to do |format|
      format.html { redirect_to courses_path, status: :see_other, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_course
      @course = Course.find(params[:id])
    end

    
    def course_params
      params.require(:course).permit(:title, :description, :short_description, :price, :languaes, :level )
    end
end
