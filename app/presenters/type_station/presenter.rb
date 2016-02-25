require 'type_station/blocks'

module TypeStation
  class Presenter < BasePresenter

    class << self
      attr_accessor :form_fields

      def form_field(name, options)
        @form_fields ||= []
        @form_fields << {name: name, type: options[:type].to_s, label: options[:label], options: options[:options], default: options[:default], required: options[:required]}
      end
    end

    def create(type, user_options = {}, &block)
      options = { type: type == :page ? nil : type, model_parent_id: @object.to_param, action: :create }.merge(user_options)
      entity_block(h.capture(&block), options)
    end

    def edit(user_options = {}, &block)
      options = { action: :edit, presenter: self.class }.merge(user_options)
      entity_block(h.capture(&block), options)
    end

    def delete(user_options = {}, &block)
      options = { action: :delete }.merge(user_options)
      entity_block(h.capture(&block), options)
    end

    def move(direction, user_options = {}, &block)
      options = { action: :move, options: { direction: "move_#{direction}"} }.merge(user_options)
      entity_block(h.capture(&block), options)
    end

    def field(name, user_options = {}, &block)
      content = ''
      options = { type: :text, field: name, url: h.type_station.admin_entity_url(@object) }.merge(user_options)

      content_attribute = @object.get name

      if content_attribute.present?
        content_presenter = ContentPresenter.new(content_attribute, h)

        if content_presenter.value_is_hash?
          content += h.capture(content_presenter, &block)
        else
          content += content_presenter.value
        end
      else
        content += h.capture(ContentPresenter.new(nil,h), &block)
      end

      TypeStation::Blocks::Field.new(h.type_station_authorise, @object, options).render(content)
    end

    private

    def entity_block(content, options = {})
      unless options[:fields]
        presenter_klass = options[:presenter] || "#{(options[:type] || @object._type).to_s.classify}Presenter".constantize
        options[:fields] = presenter_klass.form_fields || []
      end

      options[:url] = h.type_station.admin_entity_url(@object)
      options[:create_url] = h.type_station.admin_entities_url

      TypeStation::Blocks::Entity.new(h.type_station_authorise, @object, options).render(content)
    end

  end
end
