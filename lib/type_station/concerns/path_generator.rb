module TypeStation
  module Concerns
    module PathGenerator
      extend ActiveSupport::Concern

      included do

        field :title, type: String, default: 'Untitled'
        field :slug, type: String
        field :path, type: String
        field :old_paths, type: Array, default: []

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
          search_path = File.join('',path)
          pages = self.or({path: search_path}, {:old_paths.in  => [search_path]}).to_a
          pages.select {|p| p.path == search_path}.first.presence || pages.select {|p| p.old_paths.include?(search_path) }.first
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
        store_old_path
        self.path = root? ? "/" : self.ancestors_and_self.collect(&:slug).join('/')
      end

      def store_old_path
        if self.path.present?
          self.old_paths << self.path
          self.old_paths.uniq
        end
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
