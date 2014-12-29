require 'mail'

require File.join(File.dirname(__FILE__), 'utils')

module Dmail
  module Impl
    include Utils
    include Term::ANSIColor

    DOCS_PATH = File.join(File.dirname(__FILE__), '..', '..', 'doc')

    def help
      doc = ARGV[1].nil? ? 'main.txt' : "dmail-#{ARGV[1]}.txt"
      puts IO.read(File.join(DOCS_PATH, doc))
    end

    def list
      params = get_params(
        :mailbox,
        count: %w(-c --count),
        unread: %w(-u --unread)
      )
      query = { read_only: true, order: :asc, what: :first }
      query[:mailbox] = params[:mailbox] || 'INBOX'
      query[:count] = params[:count].nil? ? 10 : params[:count].to_i
      query[:keys] = 'UNSEEN' if params[:unread]

      setup_pager!
      Mail.find(query).each { |email| print_email_header(email) }
    end

    def show
      params = get_params(
        :mailbox,
        leave_unread: %w(-m --leave-unread)
      )
      query = {}
      query[:mailbox] = params[:mailbox] || 'INBOX'
      query[:read_only] = true if params[:leave_unread]

      message_id = ARGV[1]
      if message_id then
        query[:keys] = "HEADER Message-id #{message_id}"
      else
        query[:what] = :last
        query[:count] = 1
      end

      setup_pager!
      [Mail.find(query)].flatten.each do |email|
        print_email_header(email)
        puts
        puts email.text_part.decoded.strip
        puts
      end
    end

    def status
      params = get_params(:mailbox)
      query = { keys: 'UNSEEN', read_only: true }
      query[:mailbox] = params[:mailbox] || 'INBOX'
      query[:count] = 1000 # Hack to read all unreads and not only 10
      unseen = Mail.find(query).count
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