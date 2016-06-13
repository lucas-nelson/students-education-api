# Handle requests relating to a school_class
class SchoolClassesController < ApplicationController
  before_action :set_school_class, only: [:destroy, :show, :update]

  def create
    @school_class = SchoolClass.new(school_class_params)
    if @school_class.save
      render json: @school_class, status: :created, location: @school_class
    else
      render_jsonapi_errors @school_class
    end
  end

  def destroy
    @school_class.destroy
  end

  def index
    @school_classes = SchoolClass.all
    render json: @school_classes
  end

  def show
    render json: @school_class
  end

  def update
    if @school_class.update(school_class_params)
      render json: @school_class
    else
      render_jsonapi_errors @school_class
    end
  end

  private

    def set_school_class
      @school_class = SchoolClass.find(params[:id])
    end

    def school_class_params
      params
        .require(:data)
        .require(:attributes)
        .permit(:name, :teacher_id)
    end
end
