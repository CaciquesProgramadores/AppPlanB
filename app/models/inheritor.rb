# frozen_string_literal: true

require_relative 'note'

module LastWillFile
  # Behaviors of the currently logged in account
  class Inheritor
    attr_reader :id, :description, :relantionship, :emails, # basic info
                :phones, :nickname, :pgp, :fullname, :note # full details

    def initialize(info)
      process_attributes(info['attributes'])
      process_included(info['include'])
    end

    private

    def process_attributes(attributes)
      @id            = attributes['id']
      @description   = attributes['description']
      @relantionship  = attributes['relantionship']
      @emails        = attributes['emails']
      @phones        = attributes['phones']
      @nickname      = attributes['nickname']
      @pgp           = attributes['pgp']
      @fullname      = attributes['fullname']

    end

    def process_included(included)
      @note = Note.new(included['note'])
    end
  end
end