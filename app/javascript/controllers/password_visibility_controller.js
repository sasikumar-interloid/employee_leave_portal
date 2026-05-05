import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  toggle(event) {
    const button = event.currentTarget
    const inputId = button.dataset.passwordVisibilityInputId
    const input = this.inputTargets.find((field) => field.id === inputId)

    if (!input) return

    const visible = input.type === "password"

    input.type = visible ? "text" : "password"
    button.setAttribute("aria-label", visible ? "Hide password" : "Show password")
    button.setAttribute("aria-pressed", visible ? "true" : "false")

    const showIcon = button.querySelector('[data-password-visibility-icon="show"]')
    const hideIcon = button.querySelector('[data-password-visibility-icon="hide"]')

    showIcon?.classList.toggle("hidden", visible)
    hideIcon?.classList.toggle("hidden", !visible)
  }
}
