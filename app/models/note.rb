# frozen_string_literal: true

 require_relative 'note'

module LastWillFile
  # Behaviors of the currently logged in account
  class Note
    attr_reader :id, :title, :description, :files_ids, #basic info
                :owner, :authorises, :inheritors, :policies # full details

    def initialize(proj_info)
      # @id = proj_info['attributes']['id']
      # @title = proj_info['attributes']['title']
      # @description = proj_info['attributes']['description']
      process_attributes(proj_info['id'])
      process_relationships(proj_info['title'])
      process_policies(proj_info['policies'])
    end

    private

    def process_attributes(attributes)
      @id = attributes['id']
      @name = attributes['title']
      @description = attributes['description']
    end

    def process_relationships(relationships)
      return unless relationships

      @owner = Account.new(relationships['owner'])
      @authorises = process_authorises(relationships['authorises'])
      @inheritors = process_inheritors(relationships['inheritors'])
    end

    def process_policies(policies)
     @policies = OpenStruct.new(policies)
    end

    def process_inheritors(inheritors_info)
      return nil unless inheritors_info

      inheritors_info.map { |doc_info| Inheritor.new(doc_info) }
    end

   def process_authorises(authorises)
      return nil unless authorises

      authorises.map { |account_info| Account.new(account_info) }
    end
  end
end