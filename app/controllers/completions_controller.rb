# Handles requests relating to a single Completion
class CompletionsController < ApplicationController
  before_action :set_completion

  def destroy
    @completion.destroy
  end

  def show
    render json: @completion
  end

  private

    def completions_params
      params.require(:data)
            .require(:attributes)
            .permit(:lesson_part_id)
    end

    def set_completion
      @completion = Completion.find(params[:id])
    end
end
