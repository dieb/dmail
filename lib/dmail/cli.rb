require 'mail'
require 'yaml'

require File.join(File.dirname(__FILE__), 'impl')

module Dmail
  class CLI
    include Impl

    def initialize
      @action = ARGV.first.gsub('--', '')
      @coloring = true
      load_preferences
    end

    def run
      send(@action)
    end

    def help
      puts 'TODO help'
    end

    private

    def load_preferences
      retriever_preferences = preferences['dmail']['reading']

      Mail.defaults do
        retriever_method(
          retriever_preferences['method'].to_sym,
          address: retriever_preferences['address'],
          port: retriever_preferences['port'],
          user_name: retriever_preferences['user_name'],
          password: retriever_preferences['password'],
          enable_ssl: retriever_preferences['enable_ssl']
        )
      end
    end

    def preferences
      @preferences ||= if File.exists?('.dmailrc.yaml')
        YAML.load(IO.read('.dmailrc.yaml'))
      elsif File.exists?('~/.dmailrc.yaml')
        YAML.load(IO.read('~/.dmailrc.yaml'))
      else
        fail('dmail: could not find .dmailrc.yaml here or on your home directory.')
      end
    end
  end
end
