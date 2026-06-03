import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Auto-dismiss flash alert after 4 seconds
    this.timeout = setTimeout(() => {
      this.dismiss()
    }, 4000)
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  dismiss() {
    this.element.classList.add("opacity-0", "translate-y-2", "transition-all", "duration-500")
    setTimeout(() => {
      this.element.remove()
    }, 500)
  }
}
