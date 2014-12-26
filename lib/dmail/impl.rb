require 'mail'
require 'term/ansicolor'
require 'pager'

module Dmail
  module Impl
    include Pager
    include Term::ANSIColor

    def list
      params = get_params(
        :mailbox,
        count: %w(-c --count),
        unread: %w(-u --unread)
      )
      options = { read_only: true, order: :asc, what: :first }
      options[:mailbox] = params[:mailbox] || 'INBOX'
      options[:count] = params[:count].nil? ? 10 : params[:count].to_i
      options[:keys] = 'UNSEEN' if params[:unread]

      page

      Mail.find(options).each do |email|
        puts yellow { "id #{email.message_id}" }
        puts "From: #{email.from.first}"
        puts "Date: #{email.date.rfc2822}"
        puts "Message ID: #{email.message_id}" if @all
        puts
        puts "    #{email.subject}"
        puts
      end
    end

    def show
      page
      message_id = ARGV[1]

      message = if message_id then
        Mail.find(keys: "HEADER Message-id #{message_id}")
      else
        Mail.find(what: :last, count: 1)
      end

      [message].flatten.each do |email|
        puts yellow { "id #{email.message_id}" }
        puts "From: #{email.from.first}"
        puts "Date: #{email.date.rfc2822}"
        puts "Message ID: #{email.message_id}" if @all
        puts
        puts "    #{email.subject}"
        puts "\n"
        puts email.text_part.decoded.strip
        puts
      end
    end

    def status
      common_options = { mailbox: 'INBOX', read_only: true }
      unseen = Mail.find(common_options.merge(keys: 'UNSEEN', count: 1000)).count
      puts "Unread: #{unseen}"
    end

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