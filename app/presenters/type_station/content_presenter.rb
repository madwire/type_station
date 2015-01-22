module TypeStation
  class ContentPresenter < BasePresenter
    presents :content

    def value
      content.get
    end

  end
end