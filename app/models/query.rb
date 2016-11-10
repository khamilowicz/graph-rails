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

  UserType = GraphQL::ObjectType.define do
    name "user"

    interfaces [GraphQL::Relay::Node.interface]

    global_id_field :id
    field :name, types.String

    field :posts, types[PostType]
    # connection :posts, PostType.connection_type
  end

  PostType = GraphQL::ObjectType.define do
    name "post"
    interfaces [GraphQL::Relay::Node.interface]

    global_id_field :id

    field :title, types.String
    field :content, types.String

    field :user, UserType
  end

  QueryType = GraphQL::ObjectType.define do
    name "query"

    field :user do
      type UserType

      argument :id, !types.ID

      resolve ->(obj, args, ctx) do
        GlobalID::Locator.locate(args["id"])
      end
    end

    # field :node, GraphQL::Relay::Node.field

    field :users do
      type types[UserType]

      resolve ->(obj, args, ctx) do
        includes = ::Query.find_includes(ctx)
        User.all.includes(includes).to_a
      end
    end
  end

  Schema = GraphQL::Schema.define do
    query QueryType
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

  def self.call(graph_request)
    Schema.execute(graph_request, except: Mask)
  end
end
