module Teachers
  # Reports on the progress of each student a teacher has
  class ProgressOfStudentsController < ApplicationController
    before_action :set_teacher

    def index
      render json: Student.last_completions(@teacher).map { |lc| ProgressOfStudent.new(lc) },
             each_serializer: ProgressOfStudentSerializer,
             include: 'lesson_part,lesson_part.lesson,student'
    end

    private

      def set_teacher
        @teacher = Teacher.find(params[:teacher_id])
      end
  end
end
