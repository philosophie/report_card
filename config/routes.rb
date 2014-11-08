Rails.application.routes.draw do
  namespace :report_card do
    resources :reports, only: [:index, :create]
  end
end
