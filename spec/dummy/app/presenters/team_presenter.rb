class TeamPresenter < TypeStation::Presenter
  presents :team

  form_field :first_name, type: :text, label: 'First name'
  form_field :last_name, type: :text, label: 'Last name'
end
