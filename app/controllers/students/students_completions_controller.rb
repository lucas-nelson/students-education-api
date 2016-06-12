module Students
  # Handles adding and listing the link between a Student and a LessonPart
  # that is: recording a Student completing a LessonPart
  class StudentsCompletionsController < ApplicationController
    before_action :set_student

    def create
      @student.lesson_parts << lesson_part
      return if @student.save

      render_jsonapi_errors @student
    end

    def index
      render json: @student.completions
    end

    private

      def lesson_part
        LessonPart.find(students_completions_params[:lesson_part_id])
      end

      def students_completions_params
        params.require(:data)
              .require(:attributes)
              .permit(:lesson_part_id)
      end

      def set_student
        @student = Student.find(params[:student_id])
      end
  end
end
