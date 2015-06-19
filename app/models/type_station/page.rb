module TypeStation
  class Page < Entity
    include ::TypeStation::Concerns::PathGenerator
    include ::TypeStation::Concerns::Templatable

    STATUS = [:hidden, :draft, :published]

    field :redirect_to, type: String, default: nil
    field :status, type: Symbol, default: STATUS.last # always published unless stated

    # Validate that they is only one root page
    validates_each :parent_id do |model, attr, value|
      root_page = TypeStation::Page.root
      model.errors.add(attr, 'already have a root page') if value == nil && root_page.present? && model.id != root_page.id
    end

    # INSTANT METHODS

    def redirect?
      redirect_to.present?
    end

    def visible?(user)
      return true if parent_id == nil # The root page is always visible

      if user.present?
        [:draft, :published].include?(status)
      else
        status == :published
      end
    end

  end
end
