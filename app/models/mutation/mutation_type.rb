module Mutation
  MutationType = GraphQL::ObjectType.define do
    name "mutation"

    field :addOpinion, field: AddOpinionMutation.field
  end
end
