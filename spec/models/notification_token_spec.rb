# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationToken, type: :model do
  describe 'Table' do
    it 'should have table name translations' do
      expect(I18n.exists?('activerecord.models.notification_token.one')).to be_truthy,
                                                                            'Column translation missing: NotificationToken(:one)'
      expect(I18n.exists?('activerecord.models.notification_token.other')).to be_truthy,
                                                                              'Column translation missing: NotificationToken(:other)'
    end

    columns = %i[uuid
                 user_id
                 token
                 token_type
                 created_by_id
                 updated_by_id
                 active
                 deleted_at
                 created_at
                 updated_at
                 account_id]

    columns.each do |column|
      it { should have_db_column(column) }
    end

    columns_with_index = %i[account_id
                            active
                            created_by_id
                            deleted_at
                            updated_by_id
                            user_id
                            uuid]

    columns_with_index.each do |column|
      it { should have_db_index(column) }
    end

    it 'columns translations' do
      columns.each do |column|
        expect(I18n.exists?("activerecord.attributes.notification_token.#{column}")).to be_truthy,
                                                                                        "Column translation missing: #{column}"
      end
    end
  end

  describe 'ActiveStorage attachments' do
  end

  describe 'Belongs_to associations' do
    it { should belong_to(:account).conditions(active: true).class_name('::Account').inverse_of(:notification_tokens).with_foreign_key(:account_id) }
    it { should belong_to(:user).conditions(active: true).class_name('::User').inverse_of(:notification_tokens).with_foreign_key(:user_id) }
  end

  describe 'Has_many associations' do
  end

  describe 'Scopes' do
    it 'list' do
      expect(::NotificationToken.list).to be_an_scope_attributes
    end

    it 'list' do
      expect(::NotificationToken.by_user_id(::Faker::Number.digit)).to be_an_scope_attributes
    end
  end

  describe 'class validations' do
    it { should validate_presence_of(:token) }
    it { should validate_presence_of(:token_type) }
  end

  describe 'Methods' do
  end
end
