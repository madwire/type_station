module TypeStation
  module Concerns
    module PathGenerator
      extend ActiveSupport::Concern

      included do

        field :title, type: String, default: 'Untitled'
        field :slug, type: String
        field :path, type: String

        # VALIDATIONS

        validates :slug, uniqueness: true, on: :update
        validates :path, presence: true, uniqueness: true, on: :update

         # CALLBACKS
        before_create :generate_slug
        before_destroy :destroy_children
        after_rearrange :rebuild_path

        # Rebuild self and children paths upon title change
        before_save :generate_slug, if: :title_changed?
        after_save :rebuild_child_paths, if: :has_children?

      end

      module ClassMethods

        def find_by_path(path)
          self.where(path: File.join('',path)).first
        end

      end

      private

      # Generates a slug based of the title give by the user
      def generate_slug
        self.slug = root? ? "" : title.parameterize
        rebuild_path
      end

      # Rebuild a path based of a ancestors slugs
      def rebuild_path
        self.path = root? ? "/" : self.ancestors_and_self.collect(&:slug).join('/')
      end

      def rebuild_child_paths
        self.children.each do |child|
          if child.respond_to?(:rebuild_path)
            child.send :rebuild_path
            child.save
          end
        end
      end

    end
  end
end
