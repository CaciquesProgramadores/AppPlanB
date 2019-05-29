# frozen_string_literal: true

 require_relative 'note'

module LastWillFile
  # Behaviors of the currently logged in account
  class Note
    attr_reader :id, :name, :description, :files_ids, #basic info
                :owner, :inheritors # full details

    def initialize(proj_info)
      # @id = proj_info['attributes']['id']
      # @title = proj_info['attributes']['title']
      # @description = proj_info['attributes']['description']
      process_attributes(proj_info['id'])
      process_relationships(proj_info['title'])
      process_policies(proj_info['description'])
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
      # @collaborators = process_collaborators(relationships['collaborators'])
      @inheritors = process_documents(relationships['inheritors'])
    end

    # def process_policies(policies)
     # @policies = OpenStruct.new(policies)
    # end

    def process_inheritors(inheritors_info)
      return nil unless inheritors_info

      inheritors_info.map { |doc_info| Inheritor.new(doc_info) }
    end

   # def process_collaborators(collaborators)
      #return nil unless collaborators

      #collaborators.map { |account_info| Account.new(account_info) }
    #end
  end
end