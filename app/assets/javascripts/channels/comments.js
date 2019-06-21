App.cable.subscriptions.create('CommentsChannel', {
  connected() {
    console.log('Comments');
    if (gon.question_id)
      this.perform('follow', { id: gon.question_id });
  },
  received(data) {
    comment = $.parseJSON(data)
    console.log(comment);
    if (gon.current_user_id != comment.user_id) {
      new_comment = JST['templates/comment']({comment: comment});
      console.log(new_comment);
      if (comment.commentable_type == "Question") {
        $('.question .comments').append(new_comment); 
      } else if (comment.commentable_type == "Answer") {
        $('#answer-'+comment.commentable_id+' .comments').append(new_comment); 
      }
    }
  }
});