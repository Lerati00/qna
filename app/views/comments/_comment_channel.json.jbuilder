json.extract! comment, :id, :body, :commentable_type, :commentable_id, :user_id, :created_at
json.user_email comment.user.email