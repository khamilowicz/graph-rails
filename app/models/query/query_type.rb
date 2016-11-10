module Query
  QueryType = GraphQL::ObjectType.define do
    name "query"

    field :user do
      type UserType

      argument :id, !types.ID

      resolve ->(obj, args, ctx) do
        GlobalID::Locator.locate(args["id"])
      end
    end

    field :users do
      type types[UserType]

      resolve ->(obj, args, ctx) do
        includes = ::Query.find_includes(ctx)
        User.all.includes(includes).to_a
      end
    end
  end
end
