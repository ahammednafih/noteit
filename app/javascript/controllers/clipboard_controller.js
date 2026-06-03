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

    const originalText = this.buttonTarget.innerHTML
    this.buttonTarget.innerHTML = `
      <svg class="h-5 w-5 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
        <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" />
      </svg>
      Copied!
    `
    this.buttonTarget.classList.add("bg-emerald-600", "text-white")
    this.buttonTarget.classList.remove("bg-slate-700")

    setTimeout(() => {
      this.buttonTarget.innerHTML = originalText
      this.buttonTarget.classList.remove("bg-emerald-600", "text-white")
      this.buttonTarget.classList.add("bg-slate-700")
    }, 2000)
  }
}
