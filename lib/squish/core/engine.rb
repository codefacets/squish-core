require 'ostruct'

module Squish
  module Core
    include ActiveSupport::Configurable

    class Engine < ::Rails::Engine

      def self.inject_user_concern
        config.user_model.constantize.send :include, Squash::UserAssociations
        config.user_model.constantize.send :include, Squash::UserConcern
      end

      def self.inject_user_associations
        Squash::Project.send :belongs_to, :owner, class_name: config.user_model, inverse_of: :owned_projects
        Squash::Project.send :has_many, :members, through: :memberships, source: :user, class_name: config.user_model
        Squash::Membership.send :belongs_to, :user, class_name: config.user_model
      end

      config.user_model = 'Squash::User' # override with your own
      config.to_prepare &method(:inject_user_concern).to_proc
      config.to_prepare &method(:inject_user_associations).to_proc

      config.autoload_paths << config.root.join('app', 'models', 'additions')
      config.autoload_paths << config.root.join('app', 'models', 'observers')
      config.autoload_paths << config.root.join('lib')

      # Activate observers that should always be running.
      config.active_record.observers = :bug_observer, :comment_observer,
          :event_observer, :watch_observer, :occurrence_observer, :deploy_observer

      # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
      # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
      config.time_zone = 'Pacific Time (US & Canada)'

      # Use SQL instead of Active Record's schema dumper when creating the database.
      # This is necessary if your schema can't be completely dumped by the schema dumper,
      # like if you have constraints or database-specific column types
      config.active_record.schema_format = :sql

    end
  end
end

require 'api/errors'