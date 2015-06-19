module TypeStation
  class AdminBarPresenter < Presenter
    presents :page

    form_field :title, type: :text, label: 'Title'
    form_field :status, type: :select, label: 'Status', options: [['Hidden', 'hidden'], ['Draft', 'draft'], ['Published', 'published']]

  end
end
