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

    const isIconOnly = button.classList.contains("index-card-button") || !button.textContent.trim()

    if (isIconOnly) {
      button.innerHTML = '<i class="fa fa-check index-link"></i>'
    } else {
      button.innerHTML = 'Copied!'
    }

    button.classList.add("btn-success")
    button.classList.remove("btn-dark")

    setTimeout(() => {
      button.innerHTML = originalText
      button.classList.remove("btn-success")
      button.classList.add("btn-dark")
    }, 2000)
  }
}
