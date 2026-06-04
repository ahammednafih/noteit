import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "dropdown" ]

  connect() {
    this.timeout = null
    this.selectedIndex = -1
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  onInput() {
    clearTimeout(this.timeout)
    const query = this.inputTarget.value.trim()

    if (query.length < 2) {
      this.closeDropdown()
      return
    }

    // Debounce for 300ms
    this.timeout = setTimeout(() => {
      const frame = this.dropdownTarget.querySelector("turbo-frame")
      if (frame) {
        frame.src = `/notes/search_public_notes?content=${encodeURIComponent(query)}`
        this.openDropdown()
      }
    }, 300)
  }

  onFocus() {
    const query = this.inputTarget.value.trim()
    if (query.length >= 2) {
      this.openDropdown()
    }
  }

  onBlur(event) {
    // Delay hiding to allow item clicks to process
    setTimeout(() => {
      this.closeDropdown()
    }, 200)
  }

  onKeydown(event) {
    const items = this.dropdownTarget.querySelectorAll(".dropdown-item:not(.disabled)")
    if (!items.length) return

    if (event.key === "ArrowDown") {
      event.preventDefault()
      this.selectedIndex = (this.selectedIndex + 1) % items.length
      this.highlightItem(items)
    } else if (event.key === "ArrowUp") {
      event.preventDefault()
      this.selectedIndex = (this.selectedIndex - 1 + items.length) % items.length
      this.highlightItem(items)
    } else if (event.key === "Enter") {
      if (this.selectedIndex >= 0 && this.selectedIndex < items.length) {
        event.preventDefault()
        items[this.selectedIndex].click()
      }
    } else if (event.key === "Escape") {
      this.closeDropdown()
    }
  }

  highlightItem(items) {
    items.forEach((item, index) => {
      if (index === this.selectedIndex) {
        item.classList.add("active")
        item.focus()
      } else {
        item.classList.remove("active")
      }
    })
  }

  openDropdown() {
    this.dropdownTarget.style.display = "block"
  }

  closeDropdown() {
    this.dropdownTarget.style.display = "none"
    this.selectedIndex = -1
  }

  submit(event) {
    if (this.inputTarget.value.trim() === "") {
      event.preventDefault()
    }
  }
}
