require_relative 'client'

class Redis
  module Commands
    def json
      JSON::Client.new self
    end
  end
end
