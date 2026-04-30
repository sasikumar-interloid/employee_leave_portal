import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    delay: { type: Number, default: 4000 }
  }

  connect() {
    this.timeout = window.setTimeout(() => {
      this.element.remove()
    }, this.delayValue)
  }

  disconnect() {
    if (this.timeout) {
      window.clearTimeout(this.timeout)
    }
  }
}
