export default flight.component(function(){

  this.attributes({
    alertSelector: 'body > .alert',
    redactorSelector: '#campaign_html_text'
  });

  this.after('initialize', function(){
    $(this.attr.alertSelector).delay(5000).slideUp(500);
    $(this.attr.redactorSelector).redactor({ minHeight: 370 });
  });

});
