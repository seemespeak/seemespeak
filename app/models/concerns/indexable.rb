require 'active_support/concern'

module Concerns
  module Indexable
    extend ActiveSupport::Concern

    included do
      attribute :id, String
    end

    module ClassMethods
      def client
        @client ||= Elasticsearch::Client.new log: true, hosts: configuration.hosts
      end

      def configuration
        ElasticsearchSettings
      end
    end

    def client
      self.class.client
    end

    def index
      client.index :id => id,
                   :type => type,
                   :index => configuration.index,
                   :body => to_hash
    end

    def type
      self.class.name.underscore
    end

    def configuration
      self.class.configuration
    end
  end
end
