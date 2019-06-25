# frozen_string_literal: true

require_relative 'note'

module LastWillFile
  # Model class existence of users
  class Existence
    attr_reader :title, :name, :less, :status

    def initialize(attributes)
      @title = attributes['title']
      @name = attributes['name']
      @less = attributes['less']
      @status = attributes['status']

      puts 'pe pe griino'
      puts @less
      puts 'pe pe griino s2'
    end
  end
end
