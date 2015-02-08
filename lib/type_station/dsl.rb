
module TypeStation
  class DSL
    
    def self.build(name, options = {}, &block)
      Page.new(name, options).call(&block)
    end

    class Page
      attr_reader :model
      def initialize(title, options = {}, parent = nil)
        @title = title
        @options = options
        @parent = parent
        @model = _build_model(@title, @options, @parent)
      end

      def call(&block)
        if block_given?
          if block.arity == 1
            block.call model
          else
            instance_eval &block
          end
        end
        model
      end

      def page(name, options = {}, &block)
        Page.new(name, options, model).call(&block)
      end

      private

      def _build_model(title, options, parent)
        parent_id = parent ? parent.id : nil
        name = options[:name]
        template_name = options[:template] || (parent ? title.parameterize('_') : 'index')
        redirect_to = options[:redirect_to]
        slug = options[:slug]
        type = options[:type] || ::TypeStation::Page::TYPES.last

        model = ::TypeStation::Page.create(title: title, name: name, template_name: template_name, type: type, redirect_to: redirect_to, parent_id: parent_id)
        
        if slug.present?
          model.slug = slug 
          model.save
        end

        model
      end

    end

  end


end