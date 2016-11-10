module Query
  TagType = GraphQL::ObjectType.define do
    name "tag"

    interfaces [GraphQL::Relay::Node.interface]

    global_id_field :id
    field :name, !types.String

    field :post do
      type PostType

      resolve ->(obj, args, ctx) do
        obj.taggings.first.taggable
      end

    end
  end
end
