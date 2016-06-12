module Students
  # Handles adding and listing the link between a Student and a LessonPart
  # that is: recording a Student completing a LessonPart
  class CompletedLessonPartsController < ApplicationController
    before_action :set_student
    before_action :set_lesson_part, only: [:destroy, :show]

    def create
      @student.lesson_parts << lesson_part_from_data
      return if @student.save

      render_jsonapi_errors @student
    end

    def destroy
      @student.lesson_parts.destroy(@lesson_part)
    end

    def index
      render json: @student.lesson_parts
    end

    def show
      # TODO: should check that @lesson_part exists in @studen.lesson_parts
      #       and 404 if it does not
      render json: @lesson_part
    end

    private

      def completed_lesson_parts_params
        params.require(:data)
              .require(:attributes)
              .permit(:lesson_part_id)
      end

      def lesson_part_from_data
        LessonPart.find(completed_lesson_parts_params[:lesson_part_id])
      end

      def set_lesson_part
        @lesson_part = LessonPart.find(params[:id])
      end

      def set_student
        @student = Student.find(params[:student_id])
      end
  end
end
