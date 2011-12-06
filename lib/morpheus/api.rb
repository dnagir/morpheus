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

      def post_json(url, data={})
        uri = URI.parse(url)
        req = ::Net::HTTP::Post.new(uri.request_uri)
        req['Accept'] = 'application/json'
        req['Content-Type'] = 'application/json'
        req.body = MultiJson.encode data
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

    class Cypher < Rest
      def query_url
        Morpheus.database.service_root.extensions.CypherPlugin.execute_query
      end

      def execute(result_class, query, params={})
        raise "Resulting class should be provided" unless result_class

        data = { :query => query, :params => params }
        result = RecursiveOpenStruct.new(post_json(query_url, data))
        raise "Can't yet handle multiple columns" unless result.columns.length == 1

        result.data.flatten.map{|x| result_class.new.tap{|n| n.update_rest!(x)} }
      end
    end

    class Gremlin
    end
  end
end

