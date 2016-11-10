module Query
  UserType = GraphQL::ObjectType.define do
    name "user"

    interfaces [GraphQL::Relay::Node.interface]

    global_id_field :id
    field :name, types.String

    # field :posts, types[PostType]
    connection :posts, PostType.connection_type
    field :opinions, types[TagType], property: :owned_tags
    # connection :posts, PostType.connection_type
  end
end
