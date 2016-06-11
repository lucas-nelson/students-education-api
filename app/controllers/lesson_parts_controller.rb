# Handle requests relating to a lesson_part
class LessonPartsController < ApplicationController
  before_action :set_lesson_part, only: [:show, :update, :destroy]

  def create
    @lesson_part = LessonPart.new(lesson_part_params)

    if @lesson_part.save
      render json: @lesson_part, status: :created, location: @lesson_part
    else
      render_jsonapi_errors @lesson_part
    end
  end

  def destroy
    @lesson_part.destroy
  end

  def index
    @lesson_parts = LessonPart.all
    render json: @lesson_parts
  end

  def show
    render json: @lesson_part
  end

  def update
    if @lesson_part.update(lesson_part_params)
      render json: @lesson_part
    else
      render_jsonapi_errors @lesson_part
    end
  end

  private

    def set_lesson_part
      @lesson_part = LessonPart.find(params[:id])
    end

    def lesson_part_params
      params.require(:data)
            .require(:attributes)
            .permit(:name, :ordinal)
    end
end
