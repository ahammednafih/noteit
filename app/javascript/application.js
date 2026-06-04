// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "@37signals/lexxy"

// Custom Turbo Confirmation Modal handler using Bootstrap 4
Turbo.setConfirmMethod((message, element) => {
  const modal = document.getElementById("turbo-confirm-modal")
  if (!modal) {
    return confirm(message)
  }

  // Set the message text in the modal
  const messageEl = document.getElementById("turbo-confirm-message")
  if (messageEl) {
    messageEl.textContent = message
  }

  const confirmBtn = document.getElementById("turbo-confirm-button")
  
  // Show the modal via global jQuery
  window.$(modal).modal("show")

  return new Promise((resolve) => {
    let confirmed = false

    const handleConfirm = () => {
      confirmed = true
      window.$(modal).modal("hide")
    }

    const handleHide = () => {
      resolve(confirmed)
      confirmBtn.removeEventListener("click", handleConfirm)
      window.$(modal).off("hidden.bs.modal", handleHide)
    }

    confirmBtn.addEventListener("click", handleConfirm)
    window.$(modal).on("hidden.bs.modal", handleHide)
  })
})
