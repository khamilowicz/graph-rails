module Query
  PostType = GraphQL::ObjectType.define do
    name "post"
    interfaces [GraphQL::Relay::Node.interface]

    global_id_field :id

    field :title, types.String
    field :content, types.String
    field :opinions, types[TagType]

    field :user, UserType
  end
end
