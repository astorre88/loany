let Timer = {
  init(el) {
    if (!el) return
    setTimeout(function () {
      window.location.href = "/"
    }, 3000)
  }
}

export default Timer
