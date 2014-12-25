require 'mail'
require 'term/ansicolor'

module Dmail
  module Impl
    include Term::ANSIColor

    def list
      Mail.find(read_only: true, what: :first, count: 10, order: :asc)[1..-1].each do |email|
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
      all = Mail.find(common_options.merge(keys: 'ALL', count: 1000)).count
      unseen = Mail.find(common_options.merge(keys: 'UNSEEN', count: 1000)).count
      puts "All: #{all}"
      puts "New: #{unseen}"
    end
  end
end