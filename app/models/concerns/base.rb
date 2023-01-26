# frozen_string_literal: true

module Base
  extend ActiveSupport::Concern

  included do
    # Associations
    belongs_to :created_by, class_name: '::User', optional: true
    belongs_to :updated_by, class_name: '::User', optional: true

    # Scopes
    scope :active, ->(active) { where(active: active) }
    scope :activated, -> { where(active: true) }
    scope :traceability, lambda {
      select('created_by.name created_by_name, updated_by.name updated_by_name')
        &.joins("LEFT JOIN users created_by ON created_by.id = #{table_name}.created_by_id")
        &.joins("LEFT JOIN users updated_by ON updated_by.id = #{table_name}.updated_by_id")
        &.includes(created_by: { photo_attachment: :blob })
    }
    scope :by_created_by_name, lambda { |name|
      where("EXISTS(SELECT 1 FROM users created_by WHERE created_by.id = #{table_name}.created_by_id "\
            'AND created_by.active IS TRUE '\
            'AND UNACCENT(created_by.name) ILIKE :name)',
            name: I18n.transliterate(name))
    }
    scope :by_created_by_id, ->(created_by_id) { where(created_by_id: created_by_id) }
    scope :by_updated_by_id, ->(updated_by_id) { where(updated_by_id: updated_by_id) }

    # Overrides methods
    def destroy
      run_callbacks(:destroy) do
        return false if errors.messages.any?

        update_columns(active: false, deleted_at: Time.zone.now)
      end
    end

    # Recover method
    def recover
      return false if errors.messages.any? || !valid?

      update(active: true, deleted_at: nil)
    end

    def deleted?
      active == false && deleted_at.present?
    end
  end
end
