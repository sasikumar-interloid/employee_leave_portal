import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  closeIfOutside(event) {
    if (this.menuTarget.open && !this.element.contains(event.target)) {
      this.menuTarget.removeAttribute("open")
    }
  }
}
