import IMask from 'imask';

let PhoneValidation = {
  init(el) {
    if (!el) return
    var maskOptions = {
      mask: '+{46} 000 00 00 00'
    }
    var mask = IMask(el, maskOptions)
  }
}

export default PhoneValidation
