class IndexPresenter < TypeStation::Presenter
  presents :page

  form_field :title, type: :text, label: 'Title'
  form_field :template_name, type: :select, label: 'Section template', options: -> { model; [['YEAH', 'eay'],['Cool', 'v'], ['Blah', 'b']] }
  form_field :test_b, type: :text, label: 'Test', default: 'ssss', required: true
  form_field :description, type: :textarea, label: 'description'

  def sections
    page.children
  end

  def teams
    Team.where(parent_id: page.id)
  end

end
