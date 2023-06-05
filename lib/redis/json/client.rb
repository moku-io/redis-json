require 'json'

class Redis
  module JSON
    class Client
      NOT_PROVIDED = ::Object.new
      private_constant :NOT_PROVIDED

      def initialize redis_client
        @redis_client = redis_client
      end

      def call command, *args
        redis_client.call [:"json.#{command}", *args]
      end

      def arrappend key, value, *values, path: NOT_PROVIDED, generate_options: {}
        value = generate value, **generate_options
        values.map! { |val| generate val, **generate_options }

        if path.eql? NOT_PROVIDED
          call __callee__, key, value, *values
        else
          call __callee__, key, path, value, *values
        end
      end

      def arrindex key, value, start=NOT_PROVIDED, stop=NOT_PROVIDED, path:, generate_options: {}
        value = generate value, **generate_options

        if start.eql? NOT_PROVIDED
          call __callee__, key, path, value
        elsif stop.eql? NOT_PROVIDED
          call __callee__, key, path, value, start
        else
          call __callee__, key, path, value, start, stop
        end
      end

      def arrinsert key, index, value, *values, path:, generate_options: {}
        value = generate value, **generate_options
        values.map! { |val| generate val, **generate_options }

        call __callee__, key, path, index, value, *values
      end

      def arrlen key, path: NOT_PROVIDED
        if path.eql? NOT_PROVIDED
          call __callee__, key
        else
          call __callee__, key, path
        end
      end

      def arrpop key, index=NOT_PROVIDED, path: NOT_PROVIDED
        if !index.eql?(NOT_PROVIDED) && path.eql?(NOT_PROVIDED)
          raise ArgumentError,
                'You cannot specify an index unless you also specify a path'
        end

        if path.eql? NOT_PROVIDED
          call __callee__, key
        elsif index.eql? NOT_PROVIDED
          call __callee__, key, path
        else
          call __callee__, key, path, index
        end
      end

      def arrtrim key, start, stop, path:
        call __callee__, key, path, start, stop
      end

      def clear key, path: NOT_PROVIDED
        if path.eql? NOT_PROVIDED
          call __callee__, key
        else
          call __callee__, key, path
        end
      end

      def debug_memory key, path: NOT_PROVIDED
        if path.eql? NOT_PROVIDED
          call __callee__, key
        else
          call __callee__, key, path
        end
      end

      def del key, path: NOT_PROVIDED
        if path.eql? NOT_PROVIDED
          call __callee__, key
        else
          call __callee__, key, path
        end
      end

      def forget key, path: NOT_PROVIDED
        if path.eql? NOT_PROVIDED
          call __callee__, key
        else
          call __callee__, key, path
        end
      end

      def get key, *paths, indent: NOT_PROVIDED, newline: NOT_PROVIDED, space: NOT_PROVIDED, parse_options: {}
        options = {
          indent:  indent,
          newline: newline,
          space:   space
        }
        options.reject! { |_name, value| value.eql?(NOT_PROVIDED) }
        options.transform_keys!(&:upcase)

        call(__callee__, key, *options.flatten, *paths)
          .then do |response|
            parse response, **parse_options if response
          end
      end

      def merge key, value, path:, generate_options: {}
        value = generate value, **generate_options

        call __callee__, key, path, value
      end

      def mget key, *keys, path:, parse_options: {}
        call(__callee__, key, *keys, path)
          .map do |response|
            parse response, **parse_options if response
          end
      end

      def mset key, path, value, *rest, generate_options: {}
        if rest.size % 3 != 0
          raise ArgumentError,
                'mset requires parameters to be in triples <key, path, value>'
        end

        value = generate value, **generate_options
        rest.map!.with_index do |item, index|
          if index % 3 == 2
            generate(item, **generate_options)
          else
            item
          end
        end

        call __callee__, key, path, value, *rest
      end

      def numincrby key, value, path:, parse_options: {}
        call(__callee__, key, path, value)
          .then do |response|
            parse response, **parse_options if response
          end
      end

      def nummultby key, value, path:, parse_options: {}
        call(__callee__, key, path, value)
          .then do |response|
            parse response, **parse_options if response
          end
      end

      def numpowby key, value, path:, parse_options: {}
        call(__callee__, key, path, value)
          .then do |response|
            parse response, **parse_options if response
          end
      end

      def objkeys key, path: NOT_PROVIDED
        if path.eql? NOT_PROVIDED
          call __callee__, key
        else
          call __callee__, key, path
        end
      end

      def objlen key, path: NOT_PROVIDED
        if path.eql? NOT_PROVIDED
          call __callee__, key
        else
          call __callee__, key, path
        end
      end

      def resp key, path: NOT_PROVIDED
        if path.eql? NOT_PROVIDED
          call __callee__, key
        else
          call __callee__, key, path
        end
      end

      # rubocop:disable Naming/MethodParameterName
      def set key, value, path:, nx: NOT_PROVIDED, xx: NOT_PROVIDED, generate_options: {}
        if !nx.eql?(NOT_PROVIDED) && !xx.eql?(NOT_PROVIDED)
          raise ArgumentError,
                'NX and XX are mutually exclusive'
        end

        value = generate value, **generate_options

        if !nx.eql?(NOT_PROVIDED)
          call __callee__, key, path, value, :NX
        elsif !xx.eql?(NOT_PROVIDED)
          call __callee__, key, path, value, :XX
        else
          call __callee__, key, path, value
        end
      end
      # rubocop:enable Naming/MethodParameterName

      def strappend key, value, path: NOT_PROVIDED, generate_options: {}
        value = generate value, **generate_options

        if path.eql? NOT_PROVIDED
          call __callee__, key, value
        else
          call __callee__, key, path, value
        end
      end

      def strlen key, path: NOT_PROVIDED
        if path.eql? NOT_PROVIDED
          call __callee__, key
        else
          call __callee__, key, path
        end
      end

      def toggle key, path:
        call __callee__, key, path
      end

      def type key, path: NOT_PROVIDED
        if path.eql? NOT_PROVIDED
          call __callee__, key
        else
          call __callee__, key, path
        end
      end

    private

      attr_reader :redis_client

      def generate object, **options
        ::JSON.generate(object, **options)
      end

      def parse json_string, **options
        ::JSON.parse(json_string, **options)
      end
    end
  end
end
