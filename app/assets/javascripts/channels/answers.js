App.cable.subscriptions.create('AnswersChannel', {
  connected() {
    console.log('Answers for question subscribed');
    if (gon.question_id)
      this.perform('follow', { id: gon.question_id });
  },
  received(data) {
    answer = $.parseJSON(data)
    if (gon.current_user_id != answer.author_id) {
      new_answer = JST['templates/answer']({answer: answer});
      console.log(new_answer);
    
      $('.answers').append(new_answer);
    }
  }
});