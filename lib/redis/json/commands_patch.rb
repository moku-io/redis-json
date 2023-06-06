require_relative 'client'

if defined?(Redis::Commands)
  class Redis
    module Commands
      def json
        JSON::Client.new self
      end
    end
  end
else
  class Redis
    def json
      JSON::Client.new self
    end
  end
end
