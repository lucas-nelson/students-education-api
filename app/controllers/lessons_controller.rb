# Handle requests relating to a lesson
class LessonsController < ApplicationController
  before_action :set_lesson, only: [:show, :update, :destroy]

  def create
    @lesson = Lesson.new(lesson_params)
    if @lesson.save
      render json: @lesson, status: :created, location: @lesson
    else
      render_jsonapi_errors @lesson
    end
  end

  def destroy
    @lesson.destroy
  end

  def index
    @lessons = Lesson.all
    render json: @lessons
  end

  def show
    render json: @lesson
  end

  def update
    if @lesson.update(lesson_params)
      render json: @lesson
    else
      render_jsonapi_errors @lesson
    end
  end

  private

    def set_lesson
      @lesson = Lesson.find(params[:id])
    end

    def lesson_params
      params.require(:data)
            .require(:attributes)
            .permit(:name, :ordinal)
    end
end
