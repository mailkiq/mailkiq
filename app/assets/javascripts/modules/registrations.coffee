class App.Registrations.New
  constructor: ->
    Iugu.setAccountID 'a63f657b-a787-4ac0-8e39-1b06e869dea5'

  initializeElements: ->
    @form = $('.simple_form:has(.usable-creditcard-form)')

  initializeEvents: =>
    $('.credit_card_number').keyup(@onKeyUp)
    $('.credit_card_number').formatter
      pattern: '{{9999}} {{9999}} {{9999}} {{9999}}'
      persistent: false

    $('.credit_card_expiration').formatter
      pattern: '{{99}}/{{99}}',
      persistent: false

    $('.credit_card_cvv').formatter pattern: '{{9999}}'

    @form.submit @onSubmit

  onSubmit: (ev) ->
    form = $(this).get(0)
    submitButton = $(this).find(':submit')
    submitButton.prop('disabled', true)

    if not $('.usable-creditcard-form').length
      return form.submit()

    Iugu.createPaymentToken this, (response) ->
      console.log(response) if console
      if response.errors
        alert('Erro na Cobrança. Verifique os dados do cartão de crédito.')
        submitButton.prop('disabled', false)
      else
        $('#account_credit_card_token').val(response.id)
        form.submit()

    return false

  onKeyUp: (ev) =>
    number = $(ev.target).val()
    number = number.replace(/\ /g, '')
    number = number.replace(/\-/g, '')
    brand = Iugu.utils.getBrandByCreditCardNumber(number)

    @form
      .removeClass('visa')
      .removeClass('mastercard')
      .removeClass('amex')
      .removeClass('diners')

    if brand
      @form.addClass(brand)

      if brand == 'amex'
        @form.find('.credit_card_number').formatter()
          .resetPattern('{{9999}} {{9999999}} {{99999}}')
      else if brand == 'diners'
        @form.find('.credit_card_number').formatter()
          .resetPattern('{{9999}} {{999999}} {{9999}}')
      else
        @form.find('.credit_card_number').formatter()
          .resetPattern('{{9999}} {{9999}} {{9999}} {{9999}}')

    return true

  render: ->
    @initializeElements()
    @initializeEvents()

class App.Registrations.Edit extends App.Registrations.New
