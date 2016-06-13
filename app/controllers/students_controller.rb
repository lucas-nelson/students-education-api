# Handle requests relating to a student
class StudentsController < ApplicationController
  before_action :set_student, only: [:destroy, :show, :update]

  def create
    @student = Student.new(student_params)
    if @student.save
      render json: @student, status: :created, location: @student
    else
      render_jsonapi_errors @student
    end
  end

  def destroy
    @student.destroy
  end

  def index
    @students = Student.all
    render json: @students
  end

  def show
    render json: @student
  end

  def update
    if @student.update(student_params)
      render json: @student
    else
      render_jsonapi_errors @student
    end
  end

  private

    def set_student
      @student = Student.find(params[:id])
    end

    def student_params
      params
        .require(:data)
        .require(:attributes)
        .permit(:email, :name)
    end
end
