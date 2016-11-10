module Query

  module Mask
    def self.call(schema_member)
      puts schema_member
      false
    end
  end

  UserType = GraphQL::ObjectType.define do
    name "user"

    field :id, types.ID
    field :name, types.String

    # field :posts, types[PostType]
    connection :posts, PostType.connection_type
  end

  PostType = GraphQL::ObjectType.define do
    name "post"
    interfaces [GraphQL::Relay::Node.interface]

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
        User.find(args["id"])
      end

    end

    field :node, GraphQL::Relay::Node.field

    field :users do
      type types[UserType]

      resolve ->(obj, args, ctx) do
        User.all.to_a
      end
    end
  end

  Schema = GraphQL::Schema.define do
    query QueryType
    id_from_object = ->(object, type_definition, query_ctx) {
      # Call your application's UUID method here
      # It should return a string
      MyApp::GlobalId.encrypt(object.class.name, object.id)
    }

    object_from_id = ->(id, query_ctx) {
      class_name, item_id = MyApp::GlobalId.decrypt(id)
      # "Post" => Post.find(id)
      Object.const_get(class_name).find(item_id)
    }
  end

  def self.call(graph_request)
    Schema.execute(graph_request, except: Mask)
  end
end
