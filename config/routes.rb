# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development? || Rails.env.staging?
  mount Sidekiq::Web => "/sidekiq"

  get "zip_codes/search"
  default_url_options host: "localhost:3000"

  namespace :admin do
    devise_for :users, controllers: { sessions: "admin/sessions", passwords: "admin/passwords" }, path: ""
    root "medical_institution_applying#index"

    devise_scope :user do
      get "passwords/send_mail_success", to: "passwords#send_mail_success"
      get "passwords/finish", to: "passwords#finish"
    end

    resources :medical_institutions do
      resources :candidates, only: %i[index], controller: "medical_institutions/candidates" do
        resource :account, only: %i[show], controller: "medical_institutions/candidates/account"
        resources :attendances, only: %i[index], controller: "medical_institutions/candidates/attendances"
        resources :payslips, only: %i[index], controller: "medical_institutions/candidates/payslips" do
          collection do
            get "download_pdf", to: "medical_institutions/candidates/payslips#download_pdf"
            get "timeline", to: "medical_institutions/candidates/payslips#timeline"
          end
        end
      end

      resource :invoices, only: %i[show], controller: "medical_institutions/invoices" do
        collection do
          get "download_pdf", to: "medical_institutions/invoices#download_pdf"
          get "send_mail", to: "medical_institutions/invoices#send_mail"
          get "confirm_send_mail", to: "medical_institutions/invoices#confirm_send_mail"
          get "complete_send_mail", to: "medical_institutions/invoices#complete_send_mail"
        end
      end

      member do
        post "confirm", to: "medical_institutions#confirm"
        get "confirm", to: "medical_institutions#confirm"
        get "confirm_delete", to: "medical_institutions#confirm_delete"
      end

      collection do
        post "confirm", to: "medical_institutions#confirm"
        get "confirm", to: "medical_institutions#confirm"
        get "complete", to: "medical_institutions#complete"
      end
    end

    resources :pharmaceutical_companies, only: %i[index show]

    resources :candidate_jobs, only: %i[index show] do
      resource :contract, controller: "candidate_job/contracts"
      resources :attendances, only: %i[index], controller: "candidate_job/attendances"
      resource :profile, only: %i[show], controller: "candidate_job/profiles"
      resource :payslip, only: %i[show], controller: "candidate_job/payslips" do
        collection do
          get "download_pdf", to: "candidate_job/payslips#download_pdf"
          get "send_mail", to: "candidate_job/payslips#send_mail"
          get "confirm_send_mail", to: "candidate_job/payslips#confirm_send_mail"
          get "complete_send_mail", to: "candidate_job/payslips#complete_send_mail"
        end
      end

      collection do
        get "download_batch", to: "candidate_jobs#download_batch"
        get "download_withholding_slips", to: "candidate_jobs#download_withholding_slips"
      end

      member do
        get "withholding_slip", to: "withholding_slips#show"
        get "withholding_slip/download_pdf", to: "withholding_slips#download_pdf"
        get "withholding_slip/send_mail", to: "withholding_slips#send_mail"
        get "withholding_slip/confirm_send_mail", to: "withholding_slips#confirm_send_mail"
        get "withholding_slip/complete_send_mail", to: "withholding_slips#complete_send_mail"
      end
    end

    resources :users, only: %i[new create index] do
      collection do
        post "confirm", to: "users#confirm"
        get "confirm", to: "users#confirm"
        get "complete", to: "users#complete"
      end
    end

    resources :manages, only: %i[new create edit update index destroy] do
      member do
        post "confirm", to: "manages#confirm"
        get "confirm", to: "manages#confirm"
        get "confirm_delete", to: "manages#confirm_delete"
      end

      collection do
        post "confirm", to: "manages#confirm"
        get "confirm", to: "manages#confirm"
        get "complete", to: "manages#complete"
      end
    end

    resource :account, only: %i[edit update destroy] do
      get "complete", to: "accounts#complete"
      get "confirm_delete", to: "accounts#confirm_delete"
      post "confirm", to: "accounts#confirm"
      get "confirm", to: "accounts#confirm"
    end

    resources :medical_institution_applying, only: %i[index show] do
      member do
        get "complete_approval", to: "medical_institution_applying#complete_approval"
        get "confirm_approve", to: "medical_institution_applying#confirm_approve"
        get "confirm_rejection", to: "medical_institution_applying#confirm_rejection"
      end
    end

    resource :system_setting, only: %i[show edit update] do
      post "confirm", to: "system_settings#confirm"
      get "confirm", to: "system_settings#confirm"
      get "complete", to: "system_settings#complete"
    end

    resources :notifications do
      member do
        post "confirm", to: "notifications#confirm"
        get "confirm", to: "notifications#confirm"
        get "confirm_delete", to: "notifications#confirm_delete"
      end

      collection do
        post "confirm", to: "notifications#confirm"
        get "confirm", to: "notifications#confirm"
        get "complete", to: "notifications#complete"
      end
    end
    resources :tax_withholdings, only: %i[index create update destroy] do
      collection { post :import }
    end
  end

  namespace :medical do
    devise_for :users, controllers: { sessions: "medical/sessions", registrations: "medical/registrations", passwords: "medical/passwords" }, path: ""
    devise_scope :user do
      post "sign_up/confirm", to: "registrations#confirm"
      get "sign_up/confirm", to: "registrations#confirm"
      get "sign_up/complete", to: "registrations#complete"
      get "passwords/send_mail_success", to: "passwords#send_mail_success"
      get "passwords/finish", to: "passwords#finish"
    end
    resources :medical_institutions do
      collection do
        post "confirm", to: "medical_institutions#confirm"
        get "confirm", to: "medical_institutions#confirm"
        get "complete", to: "medical_institutions#complete"
      end
    end

    root "jobs#index"
    resources "terms", to: "terms/index"

    resources :jobs do
      collection do
        post "next_step", to: "jobs#next_step"
        get "next_step", to: "jobs#next_step"
        post "confirm", to: "jobs#confirm"
        get "confirm", to: "jobs#confirm"
        get "save_draft", to: "jobs#save_draft"
        post "save_draft", to: "jobs#save_draft"
        get "complete", to: "jobs#complete"
      end

      member do
        post "next_step", to: "jobs#next_step"
        get "next_step", to: "jobs#next_step"
        post "confirm", to: "jobs#confirm"
        get "confirm", to: "jobs#confirm"
        get "save_draft", to: "jobs#save_draft"
        post "save_draft", to: "jobs#save_draft"
        post "end_job", to: "jobs#end_job"
        get "confirm_delete", to: "jobs#confirm_delete"
      end
    end

    resources :jobs_applied do
      collection do
        get "complete", to: "jobs_applied#complete"
      end

      member do
        post "confirm", to: "jobs_applied#confirm"
        get "confirm", to: "jobs_applied#confirm"
        post "reject", to: "jobs_applied#reject"
        get "rejection", to: "jobs_applied#rejection"
      end
    end

    resources :candidate_jobs, only: %i[index show] do
      resource :contract, controller: "candidate_job/contracts" do
        get "complete", to: "candidate_job/contracts#complete"
        get "confirm", to: "candidate_job/contracts#confirm"
        post "confirm", to: "candidate_job/contracts#confirm"
      end

      resource :profile, only: %i[show], controller: "candidate_job/profiles"
      resource :payslip, only: %i[show], controller: "candidate_job/payslips" do
        collection do
          get "download_pdf", to: "candidate_job/payslips#download_pdf"
        end
      end
      resources :attendances, only: %i[index]

      collection do
        get "download_batch", to: "candidate_jobs#download_batch"
        get "download_withholding_slips", to: "candidate_jobs#download_withholding_slips"
      end

      member do
        get "withholding_slip", to: "withholding_slips#show"
        get "withholding_slip/download_pdf", to: "withholding_slips#download_pdf"
      end
    end

    resources :chats do
      member do
        put :mark_read, to: "chats#mark_read"
      end
    end
    resources :attendances, only: %i[show update]
    resources :notifications, only: %i[index show]
    resources :faqs, only: %i[index show]
    resource :account, only: %i[edit update destroy show] do
      get "complete", to: "accounts#complete"
      get "confirm", to: "accounts#confirm"
      post "confirm", to: "accounts#confirm"
      get "confirm_delete", to: "accounts#confirm_delete"
      get "delete_complete", to: "accounts#delete_complete"
    end

    resource :invoices, only: %i[show] do
      collection do
        get "download_pdf", to: "invoices#download_pdf"
      end
    end

    # TODO: Remove all resources :cronjob_testing when deploy source to production
    if Rails.env.development? || Rails.env.staging?
      resources :cronjob_testing, only: %i[index], controller: "cronjob_testing" do
        collection do
          get "generate_data", to: "cronjob_testing#generate_data"
          get "reset_data", to: "cronjob_testing#reset_data"
        end
      end
    end

    resources :contacts, only: %i[new create] do
      member do
        post "confirm", to: "contacts#confirm"
        get "confirm", to: "contacts#confirm"
      end

      collection do
        post "confirm", to: "contacts#confirm"
        get "confirm", to: "contacts#confirm"
        get "complete", to: "contacts#complete"
      end
    end
  end

  scope module: "employee", path: "" do
    root "jobs#index"
    resources "terms", to: "terms/index"

    devise_for :users, controllers: { sessions: "employee/sessions", passwords: "employee/passwords" }, path: ""
    devise_scope :user do
      post "sign_up/create", to: "registrations#create"
      post "sign_up/confirm", to: "registrations#confirm"
      get "sign_up/confirm", to: "registrations#confirm"
      post "sign_up/profile", to: "registrations#create_profile"
      get "sign_up/profile", to: "registrations#create_profile"
      get "sign_up/complete", to: "registrations#complete"
      get "passwords/send_mail_success", to: "passwords#send_mail_success"
      get "passwords/finish", to: "passwords#finish"
    end
    resources :candidates
    resources :jobs, only: %i[index show]
    resources :jobs_applied, only: %i[index show new create] do
      member do
        post "decline", to: "jobs_applied#decline"
        post "recruitment", to: "jobs_applied#recruitment"
      end
    end
    resource :account, only: %i[edit update destroy show] do
      get "complete", to: "accounts#complete"
      get "confirm", to: "accounts#confirm"
      post "confirm", to: "accounts#confirm"
      get "confirm_delete", to: "accounts#confirm_delete"
      get "delete_complete", to: "accounts#delete_complete"
    end

    resource :bank, only: %i[show create edit update] do
      get "complete", to: "banks#complete"
      get "confirm", to: "banks#confirm"
      post "confirm", to: "banks#confirm"
    end

    resource :profile, only: %i[edit update show] do
      get "complete", to: "profiles#complete"
    end

    resources :attendances, except: :destroy do
      member do
        post :submit
        post :cancel
      end
    end

    resources :payslips, only: :index do
      collection do
        get "timeline", to: "payslips#timeline"
        get "download_pdf", to: "payslips#download_pdf"
      end
    end
    resources :chats do
      member do
        put :mark_read, to: "chats#mark_read"
      end
    end
    resources :working_medicals, only: :index
    resources :candidate_jobs, only: [] do
      member do
        post :upload_attachment
      end
    end
    resources :notifications, only: %i[index show]
    resources :faqs, only: %i[index show]
    resources :withholding_slips, only: :index do
      collection do
        get "download_pdf", to: "withholding_slips#download_pdf"
      end
    end

    resources :contacts, only: %i[new create] do
      member do
        post "confirm", to: "contacts#confirm"
        get "confirm", to: "contacts#confirm"
      end

      collection do
        post "confirm", to: "contacts#confirm"
        get "confirm", to: "contacts#confirm"
        get "complete", to: "contacts#complete"
      end
    end
  end
end
