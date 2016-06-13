module Teachers
  # Shows a how teachers relate to students
  class TeachesStudentsController < ApplicationController
    before_action :set_student

    def index
      render json: Student.taught_by(@teacher)
    end

    private

      def set_student
        @teacher = Teacher.find(params[:teacher_id])
      end
  end
end
