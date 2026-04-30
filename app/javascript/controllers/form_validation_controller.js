import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["field"]

  validateForm(event) {
    const invalidFields = this.fieldTargets.filter((field) => !this.validate(field))

    if (invalidFields.length > 0) {
      event.preventDefault()
      invalidFields[0].focus()
    }
  }

  validateField(event) {
    const field = this.fieldTargets.find((target) => target === event.target)

    if (field) {
      this.validate(field)
      this.refreshDependents(field)
    }
  }

  validate(field) {
    field.setCustomValidity("")

    const value = field.value.trim()
    const requiredMessage = field.dataset.formValidationRequiredMessage
    const matchFieldId = field.dataset.formValidationMatchFieldId
    const matchMessage = field.dataset.formValidationMatchMessage
    const requiredIfFieldId = field.dataset.formValidationRequiredIfFieldId

    if (requiredIfFieldId) {
      const relatedField = document.getElementById(requiredIfFieldId)

      if (relatedField && relatedField.value.trim() !== "" && value === "") {
        field.setCustomValidity(requiredMessage || "This field is required.")
      }
    }

    if (field.validity.valueMissing && requiredMessage) {
      field.setCustomValidity(requiredMessage)
    }

    if (field.validity.tooShort) {
      field.setCustomValidity(`Must be at least ${field.minLength} characters.`)
    }

    if (field.validity.typeMismatch && field.type === "email") {
      field.setCustomValidity("Enter a valid email address.")
    }

    if (field.validity.patternMismatch) {
      field.setCustomValidity(field.dataset.formValidationPatternMessage || "Enter a valid value.")
    }

    if (matchFieldId) {
      const matchField = document.getElementById(matchFieldId)

      if (matchField && value !== "" && value !== matchField.value) {
        field.setCustomValidity(matchMessage || "This field does not match.")
      }
    }

    const isValid = field.checkValidity()

    if (isValid) {
      this.clearError(field)
    } else {
      this.showError(field, field.validationMessage)
    }

    return isValid
  }

  refreshDependents(field) {
    this.fieldTargets
      .filter((target) => target.dataset.formValidationRequiredIfFieldId === field.id || target.dataset.formValidationMatchFieldId === field.id)
      .forEach((target) => this.validate(target))
  }

  showError(field, message) {
    let error = this.errorElementFor(field)

    if (!error) {
      error = document.createElement("p")
      error.id = `${field.id}-error`
      error.className = "mt-2 text-xs text-rose-600"
      field.insertAdjacentElement("afterend", error)
    }

    error.textContent = message
    field.setAttribute("aria-invalid", "true")
    field.setAttribute("aria-describedby", error.id)
    field.classList.add("border-rose-500", "focus:border-rose-500")
  }

  clearError(field) {
    const error = this.errorElementFor(field)

    if (error) {
      error.remove()
    }

    field.removeAttribute("aria-invalid")
    field.removeAttribute("aria-describedby")
    field.classList.remove("border-rose-500", "focus:border-rose-500")
  }

  errorElementFor(field) {
    return this.element.querySelector(`#${field.id}-error`)
  }
}
