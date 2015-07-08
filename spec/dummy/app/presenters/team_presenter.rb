class TeamPresenter < TypeStation::Presenter
  presents :team

  form_field :first_name, type: :text, label: 'First name'
  form_field :last_name, type: :text, label: 'Last name'
  form_field :template_name, type: :select, label: 'Section template', options: [['Cool', 'v'], ['Blah', 'b']]
end
