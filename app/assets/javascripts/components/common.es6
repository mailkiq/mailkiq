export default flight.component(function(){

  this.attributes({
    alertSelector: 'body > .alert'
  });

  this.after('initialize', function(){
    $(this.attr.alertSelector).delay(5000).slideUp(500);
  });

});
