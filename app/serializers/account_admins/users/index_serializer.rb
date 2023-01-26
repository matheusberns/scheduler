# frozen_string_literal: true

module AccountAdmins
  module Users
    class IndexSerializer < BaseSerializer
      attributes attributes :name,
                            :email,
                            :last_sign_in_at,
                            :photo,
                            :customer_id

      def last_sign_in_at
        object.last_sign_in_at&.iso8601
      end
    end

    def photo
      object.photo_dimensions
    end
  end
end
