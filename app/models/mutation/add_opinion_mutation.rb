module Mutation
  AddOpinionMutation = GraphQL::Relay::Mutation.define do
    name "AddOpinion"

    input_field :post_id, !types.ID
    input_field :user_id, !types.ID
    input_field :content, !types.String

    return_field :opinion, ::Query::TagType

    resolve ->(obj, inputs, ctx) do
      post = Post.find(inputs[:post_id])
      user = User.find(inputs[:user_id])
      user.tag(post, with: inputs[:content], on: :opinions)
      {opinion: post.opinions.last}
    end
  end
end
