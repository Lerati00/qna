$(document).on('turbolinks:load', function(){
  $('.question').on('click', '.edit-question-link', function(e) {
      e.preventDefault();
      $(this).hide();
      $('.edit-question').removeClass('hidden');
  })

  $('.question .rating').on('ajax:success', function(e) {
    var result = e.detail[0];
    console.log(result.question.score)
    $('.question .score').text(result.question.score)
  })

  App.cable.subscriptions.create('QuestionsChannel', {
    connected() {
      console.log('Connected')
      return this.perform('follow')
    },
    received(data) {
      $('.questions-list').append(data)
    }
  })
});
