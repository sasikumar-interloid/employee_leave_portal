import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "toggleLabel"]

  toggle(event) {
    const visible = event.currentTarget.checked

    this.inputTargets.forEach((input) => {
      input.type = visible ? "text" : "password"
    })

    if (this.hasToggleLabelTarget) {
      this.toggleLabelTarget.textContent = visible ? "Hide password" : "Show password"
    }
  }
}
