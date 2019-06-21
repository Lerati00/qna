json.extract! answer, :id,  :body, :score, :question_id, :author_id, :best
json.vote_up_path polymorphic_path(answer, action: :vote_up)
json.vote_down_path polymorphic_path(answer, action: :vote_down)
json.vote_cancel_path polymorphic_path(answer, action: :vote_cancel)
json.set_best_path best_answer_path(answer)
json.delete_path answer_path(answer)

json.files answer.files do |file|
  json.name file.filename
  json.url url_for(file)
  json.id file.id
  json.file_delete_path attachment_path(file)
end

json.links answer.links do |link|
  json.name link.name
  json.url link.url
  json.id link.id
  json.link_delete_path link_path(link)
  json.set_best_path best_answer_path(answer)
  
  if (gist?(link))
    json.is_gist true
    json.gist_files get_gist_files(link) do |file|
      json.name file[1].filename
      json.body file[1].content
    end
  end
end


