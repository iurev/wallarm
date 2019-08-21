class ActionPropertiesValidator < ActiveModel::Validator
  def validate(record)
    unless record.properties.is_a?(Hash)
      message = I18n.t('activerecord.errors.models.action.attributes.properties.invalid_json')
      record.errors.add(:properties, message)
    end
  end
end
