# frozen_string_literal: true

module AccountAdmins
  module Users
    class ShowSerializer < BaseSerializer
      attributes :provider,
                 :uid,
                 :encrypted_password,
                 :reset_password_token,
                 :reset_password_sent_at,
                 :sign_in_count,
                 :current_sign_in_at,
                 :last_sign_in_at,
                 :current_sign_in_ip,
                 :last_sign_in_ip,
                 :confirmation_token,
                 :confirmed_at,
                 :confirmation_sent_at,
                 :unconfirmed_email,
                 :name,
                 :email,
                 :photo,
                 :active,
                 :deleted_at,
                 :created_at,
                 :updated_at,
                 :is_admin,
                 :account_id,
                 :integration_id,
                 :uuid,
                 :is_blocked,
                 :is_account_admin,
                 :last_request_at,
                 :remember_created_at,
                 :timeout_in,
                 :allow_password_change,
                 :is_integrator,
                 :created_by,
                 :updated_by,
                 :customer

      def customer
        return unless object.customer_id

        {
          id: object.customer_id,
          name: object.customer_name,
          cpf_cnpj: object.customer_cpf_cnpj
        }
      end

      def account
        return if object.account_id.nil?

        {
          id: object.account_id,
          logo: active_storage_blob_path(object.account_logo),
          toolbar_background: active_storage_blob_path(object.account_toolbar_background),
          menu_background: active_storage_blob_path(object.account_menu_background)
        }
      end

      def admission_date
        object.admission_date&.to_time&.iso8601
      end

      def photo
        object.photo_dimensions
      end

      def driver_license_photo
        object.driver_license_dimensions
      end

      def created_by
        return unless object.created_by_id

        {
          id: object.created_by_id,
          name: object.created_by_name
        }
      end

      def updated_by
        return unless object.updated_by_id

        {
          id: object.updated_by_id,
          name: object.updated_by_name
        }
      end
    end
  end
end
