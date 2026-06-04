import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "source", "button" ]

  copy(event) {
    event.preventDefault()
    
    const textToCopy = this.sourceTarget.value || this.sourceTarget.textContent || this.sourceTarget.href
    
    navigator.clipboard.writeText(textToCopy).then(() => {
      this.showFeedback()
    }).catch(err => {
      console.error("Could not copy text: ", err)
    })
  }

  showFeedback() {
    if (!this.hasButtonTarget) return

    const button = this.buttonTarget
    const originalText = button.innerHTML

    button.innerHTML = '<i class="fa fa-check"></i>'
    button.classList.add("btn-success")
    button.classList.remove("btn-dark")

    this.showToast("Copied to clipboard!")

    setTimeout(() => {
      button.innerHTML = originalText
      button.classList.remove("btn-success")
      button.classList.add("btn-dark")
    }, 2000)
  }

  showToast(message) {
    const existingToast = document.querySelector(".clipboard-toast")
    if (existingToast) existingToast.remove()

    const toast = document.createElement("div")
    toast.className = "alert alert-success clipboard-toast"
    toast.style.cssText = `
      position: fixed;
      bottom: 25px;
      right: 25px;
      z-index: 99999;
      padding: 12px 24px;
      border-radius: 4px;
      font-weight: 500;
      font-size: 14px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.15);
      margin-bottom: 0;
      opacity: 0;
      transition: opacity 0.3s ease, transform 0.3s ease;
      transform: translateY(10px);
    `
    toast.textContent = message
    document.body.appendChild(toast)

    requestAnimationFrame(() => {
      toast.style.opacity = "1"
      toast.style.transform = "translateY(0)"
    })

    setTimeout(() => {
      toast.style.opacity = "0"
      toast.style.transform = "translateY(10px)"
      setTimeout(() => toast.remove(), 300)
    }, 2000)
  }
}
