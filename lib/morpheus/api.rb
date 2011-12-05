module Morpheus
  module API

    class Rest
      def get_json(url)
        uri = URI.parse(url)
        req = ::Net::HTTP::Get.new(uri.request_uri)
        req['Accept'] = 'application/json'
        req['Content-Type'] = 'application/json'
        resp = ::Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(req)
        end
        MultiJson.decode ensure_ok(resp).body
      end

      def ensure_ok(resp)
        raise "Expected successful response, but was #{resp.inspect}" unless resp.code == '200'
        resp
      end
    end

    class Root < Rest
      def get(url)
        RecursiveOpenStruct.new(get_json url)
      end
    end

    class Nodes
    end

    class Relationships
    end

    class RelationshipTypes
    end

    class RelationshipProperties
    end

    class Indexes
    end

    class AutoIndexes
    end

    class ConfigurableAutoIndexes
    end

    class Traversals
    end

    class Algorithms
    end

    class Batching
    end

    class Cypher
    end

    class Gremlin
    end
  end
end

