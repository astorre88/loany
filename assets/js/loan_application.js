let LoanApplication = {
  init(socket, el) {
    if (!el) return
    let workerId = el.getAttribute("data-worker-id")
    socket.connect()
    this.onReady(workerId, socket, el)
  },
  onReady(workerId, socket, el) {
    console.log(`workerId: ${workerId}`)
    let applicationChannel = socket.channel("application:" + workerId)

    applicationChannel.on("scoring_check_result", resp => {
      console.log(resp)
      if (resp.rate === 0) {
        el.innerHTML = "Try again!"
        setTimeout(function () {
          window.location.href = "/"
        }, 3000)
      } else {
        el.innerHTML = `${resp.rate}%`
      }
    })

    applicationChannel.join()
      .receive("ok", resp => {
        console.log("Joined successfully", resp)
      })
      .receive("error", resp => {
        console.log("Unable to join", resp)
      })
  }
}

export default LoanApplication
