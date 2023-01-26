# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'Table' do
    it 'should have table name translations' do
      expect(I18n.exists?('activerecord.models.notification.one')).to be_truthy, 'Column translation missing: Notification(:one)'
      expect(I18n.exists?('activerecord.models.notification.other')).to be_truthy, 'Column translation missing: Notification(:other)'
    end

    columns = %i[title
                 message
                 read
                 notification_type
                 notification_origin
                 notifiable_type
                 notifiable_id
                 user_id
                 account_id
                 created_by_id
                 updated_by_id
                 active
                 deleted_at
                 created_at
                 updated_at]

    columns.each do |column|
      it { should have_db_column(column) }
    end

    columns_with_index = %i[account_id
                            active
                            created_by_id
                            deleted_at
                            message
                            read
                            title
                            updated_by_id
                            user_id]

    columns_with_index.each do |column|
      it { should have_db_index(column) }
    end

    it 'columns translations' do
      columns.each do |column|
        expect(I18n.exists?("activerecord.attributes.notification.#{column}")).to be_truthy,
                                                                                  "Column translation missing: #{column}"
      end
    end
  end

  describe 'ActiveStorage attachments' do
  end

  describe 'Belongs_to associations' do
    it { should belong_to(:account).conditions(active: true).class_name('::Account').inverse_of(:notifications).with_foreign_key(:account_id) }
    it { should belong_to(:user).conditions(active: true).class_name('::User').inverse_of(:notifications).with_foreign_key(:user_id) }
    it { should belong_to(:notifiable).conditions(active: true).optional }
  end

  describe 'Has_many associations' do
  end

  describe 'Scopes' do
    it 'list' do
      expect(::Notification.list).to be_an_scope_attributes
    end

    it 'read' do
      expect(::Notification.read(::Faker::Boolean.boolean)).to be_an_scope_attributes
    end

    it 'by_title' do
      expect(::Notification.by_title(::Faker::Name.name)).to be_an_scope_attributes
    end

    it 'by_message' do
      expect(::Notification.by_message(::Faker::Name.name)).to be_an_scope_attributes
    end

    it 'by_search' do
      expect(::Notification.by_search(::Faker::Name.name)).to be_an_scope_attributes
    end
  end

  describe 'class validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:message) }
    it { should validate_presence_of(:notification_type) }
    it { should validate_presence_of(:notification_origin) }
  end

  describe 'Methods' do
  end
end
