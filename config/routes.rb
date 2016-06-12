Rails.application.routes.draw do
  resources :completions, only: [:destroy, :show]
  resources :lesson_parts
  resources :lessons
  resources :students do
    # go a little nuts on the configuration here to get a pretty route with
    # nicely named helper, while obviously separating the CompletionsController
    # from the StudentsCompletionsController
    resources :students_completions, as: :completions, module: :students, only: [:create, :index], path: :completions
  end
end
