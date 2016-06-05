class App.Registrations.New
  constructor: ->
    Iugu.setAccountID 'a63f657b-a787-4ac0-8e39-1b06e869dea5'
    Iugu.setTestMode true

  initializeEvents: ->
    $('.credit_card_number').keyup(@onKeyUp)
    $('.credit_card_number').formatter
      pattern: '{{9999}} {{9999}} {{9999}} {{9999}}'
      persistent: false

    $('.credit_card_expiration').formatter
      pattern: '{{99}}/{{99}}',
      persistent: false

    $('.credit_card_cvv').formatter pattern: '{{9999}}'

    $('.new_account').submit @onSubmit

  onSubmit: (ev) ->
    form = $(this).get(0)

    if not $('.usable-creditcard-form').length
      return form.submit()

    Iugu.createPaymentToken this, (response) ->
      console.log(response) if console
      if response.errors
        alert("Erro na Cobrança. Verifique os dados do cartão de crédito.")
      else
        $('#account_credit_card_token').val(response.id)
        form.submit()

    return false

  onKeyUp: (ev) ->
    number = $(this).val()
    number = number.replace(/\ /g, '')
    number = number.replace(/\-/g, '')

    $('.new_account').removeClass('visa')
    $('.new_account').removeClass('mastercard')
    $('.new_account').removeClass('amex')
    $('.new_account').removeClass('diners')

    brand = Iugu.utils.getBrandByCreditCardNumber(number)

    if brand
      $('.new_account').addClass(brand)

      if brand == 'amex'
        $('.new_account .credit_card_number').formatter()
          .resetPattern('{{9999}} {{9999999}} {{99999}}')
      else if brand == 'diners'
        $('.new_account .credit_card_number').formatter()
          .resetPattern('{{9999}} {{999999}} {{9999}}')
      else
        $('.new_account .credit_card_number').formatter()
          .resetPattern('{{9999}} {{9999}} {{9999}} {{9999}}')

    return true

  render: ->
    @initializeEvents()
