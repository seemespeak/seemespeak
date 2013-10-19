require 'active_support/concern'

module Concerns
  module Indexable
    extend ActiveSupport::Concern

    class Query
      include Virtus.model

      attribute :language
      attribute :ignored_flags, Array[String] # the ignored flags
      attribute :tags, Array[String] # interesting tags
      attribute :phrase, String
      attribute :reviewed, :default => true

      def to_hash
        if phrase
          query = { :match => { :transcription => query } }
        else
          query = { :match_all => {} }
        end

        bool = Hash.new { |h,k| h[k] = [] }

        if reviewed
          bool[:must] << { :term => { :reviewed => true } }
        end

        if ignored_flags
          bool[:must_not] << { :terms => { :flags => ignored_flags } }
        end

        if tags && !tags.empty?
          bool[:must] << { :terms => { :tags => tags } }
        end

        { :query => query, :filter => bool }
      end
    end

    included do
      attribute :id, String
      attribute :version, Fixnum
    end

    module ClassMethods
      def client
        @client ||= Elasticsearch::Client.new log: true, hosts: configuration.hosts
      end

      def configuration
        ElasticsearchSettings
      end

      def get(id)
        result = client.get :id => id,
                            :index => configuration.index,
                            :type => type

        model = self.new(result["_source"])
        model.id = result["_id"]
        model.version = result["_version"]
        model
      end

      def type
        name.underscore
      end

      def search(args = {})
        query = Query.new(args)
        args[:query] = query.to_hash

        args[:index] = configuration.index
        args[:type] = type
        result = client.search args

        result["hits"]["hits"].map do |item|
          model = new(item["_source"])
          model.id = item["_id"]
          model.version = item["_version"]
          model
        end
      end
    end

    def client
      self.class.client
    end

    def index
      doc = to_hash
      doc.delete(:id)
      doc.delete(:version)

      result = client.index :id => id,
                            :type => type,
                            :index => configuration.index,
                            :body => doc

      if result["ok"]
        self.id = result["_id"]
        self.version = result["_version"]
      else
        raise "Indexing Error: #{result.inspect}"
      end
    end

    def type
      self.class.type
    end

    def configuration
      self.class.configuration
    end

    def persisted?
      self.id != nil
    end
  end
end
