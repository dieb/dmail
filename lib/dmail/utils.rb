require 'pager'
require 'term/ansicolor'

module Dmail
  module Utils
    include Pager

    # I like this naming better :)
    def setup_pager!
      page
    end

    # Converts arguments() to a pretty-named hash. Considers naming
    # substitutes when doing so.
    def get_params(keys, mappings)
      params = {}
      [keys].flatten.each do |key|
        value = arguments[key.to_s]
        params[key] = value if value
      end
      mappings.each do |final_name, substitutes|
        value = substitutes.map { |s| arguments[s] }.find { |el| el }
        params[final_name] = value if value
      end
      params
    end

    # Parsing command-line arguments. Understands things like '-d',
    # '-c', '-c 5', '--count=5', '--count 5'.
    # Non-valued args like '-d' get mapped to true to indicate presence.
    def arguments
      @args ||= {}
      unless @args.size > 0
        ARGV.each_with_index do |arg, index|
          if arg.start_with?('-')
            if index + 1 < ARGV.size
              next_arg = ARGV[index + 1]
              if next_arg.start_with?('-') then
                @args.update(argument_present_or_direct(arg))
              else
                @args.update(arg => next_arg)
              end
            else
              @args.update(argument_present_or_direct(arg))
            end
          end
        end
      end
      @args
    end

    def argument_present_or_direct(arg)
      arg, value = if arg.include?('=') then
        arg.split('=')
      else
        [arg, true]
      end
      { arg => value }
    end
  end
end