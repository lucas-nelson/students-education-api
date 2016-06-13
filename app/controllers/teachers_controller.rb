# Handle requests relating to a teacher
class TeachersController < ApplicationController
  before_action :set_teacher, only: [:destroy, :show, :update]

  def create
    @teacher = Teacher.new(teacher_params)
    if @teacher.save
      render json: @teacher, status: :created, location: @teacher
    else
      render_jsonapi_errors @teacher
    end
  end

  def destroy
    @teacher.destroy
  end

  def index
    @teachers = Teacher.all
    render json: @teachers
  end

  def show
    render json: @teacher
  end

  def update
    if @teacher.update(teacher_params)
      render json: @teacher
    else
      render_jsonapi_errors @teacher
    end
  end

  private

    def set_teacher
      @teacher = Teacher.find(params[:id])
    end

    def teacher_params
      params.require(:data)
            .require(:attributes)
            .permit(:email, :name)
    end
end
