module Query

  def self.find_includes(ctx)
    ctx
      .ast_node
      .selections
      .reject{|s| s.selections.empty?}
      .map{|s| s.name}
      .uniq
  end

  module Mask
    def self.call(schema_member)
      false
    end
  end


  Schema = GraphQL::Schema.define do
    query QueryType
    mutation ::Mutation::MutationType

    resolve_type ->(obj, ctx) do
      puts obj.inspect
      "user"
    end
    id_from_object ->(object, type_definition, query_ctx) {
      object.to_global_id.to_s
    }

    object_from_id ->(id, query_ctx) {
      ::GlobalID::Locator.locate(id)
    }
  end

  def self.call(graph_request, options = {})
    puts options
    Schema.execute(graph_request, options.merge(except: Mask))
  end
end
