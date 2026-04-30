import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "panel"]

  toggle() {
    const open = this.panelTarget.classList.contains("-translate-x-full")
    this.setOpen(open)
  }

  close() {
    this.setOpen(false)
  }

  setOpen(open) {
    this.panelTarget.classList.toggle("-translate-x-full", !open)
    this.overlayTarget.classList.toggle("hidden", !open)
    document.body.classList.toggle("overflow-hidden", open)
  }

  disconnect() {
    document.body.classList.remove("overflow-hidden")
  }
}
