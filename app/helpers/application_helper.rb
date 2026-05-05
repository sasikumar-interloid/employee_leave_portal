module ApplicationHelper
  def confirmation_token_error?(resource)
    resource.errors.of_kind?(:confirmation_token, :blank) ||
      resource.errors.of_kind?(:confirmation_token, :invalid)
  end

  def non_confirmation_errors_present?(resource)
    resource.errors.attribute_names.any? { |attribute| attribute.to_sym != :confirmation_token }
  end

  def confirmation_email_value(resource)
    resource.try(:pending_reconfirmation?) ? resource.unconfirmed_email : resource.email
  end
end
