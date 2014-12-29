require 'mail'

require File.join(File.dirname(__FILE__), 'utils')

module Dmail
  module Impl
    include Utils
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

      setup_pager!
      Mail.find(options).each { |email| print_email_header(email) }
    end

    def show
      message_id = ARGV[1]

      message = if message_id then
        Mail.find(keys: "HEADER Message-id #{message_id}")
      else
        Mail.find(what: :last, count: 1)
      end

      setup_pager!
      [message].flatten.each do |email|
        print_email_header(email)
        puts
        puts email.text_part.decoded.strip
        puts
      end
    end

    def status
      common_options = { mailbox: 'INBOX', read_only: true }
      unseen = Mail.find(common_options.merge(keys: 'UNSEEN', count: 1000)).count
      puts "Unread: #{unseen}"
    end

    private

    def print_email_header(email)
      puts yellow { "id #{email.message_id}" }
      puts "From: #{email.from.first}"
      puts "Date: #{email.date.rfc2822}"
      puts "Message ID: #{email.message_id}" if @all
      puts
      puts "    #{email.subject}"
      puts
    end
  end
end