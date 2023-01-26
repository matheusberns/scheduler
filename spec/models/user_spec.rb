# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Table' do
    it 'should have table name translations' do
      expect(I18n.exists?('activerecord.models.user.one')).to be_truthy, 'Column translation missing: User(:one)'
      expect(I18n.exists?('activerecord.models.user.other')).to be_truthy, 'Column translation missing: User(:other)'
    end

    columns = %i[provider
                 uid
                 encrypted_password
                 reset_password_token
                 reset_password_sent_at
                 sign_in_count
                 current_sign_in_at
                 last_sign_in_at
                 current_sign_in_ip
                 last_sign_in_ip
                 confirmation_token
                 confirmed_at
                 confirmation_sent_at
                 unconfirmed_email
                 name
                 email
                 active
                 deleted_at
                 created_at
                 updated_at
                 is_admin
                 birthday
                 address
                 driver_license
                 phone
                 cellphone
                 phone_extension
                 occupation
                 admission_date
                 on_vacation
                 contact_person
                 notification_token
                 cod_emp
                 cod_fil
                 department_id
                 show_intro
                 shift_id
                 godfather_id
                 web_notification_token
                 access_all_purchase_orders
                 is_blocked
                 rg
                 cpf
                 lunch_time_start
                 lunch_time_end
                 work_time_start
                 work_time_end
                 is_account_admin
                 last_request_at
                 timeout_in
                 original_name
                 dont_show_birthday
                 account_id
                 uuid
                 created_by_id
                 updated_by_id
                 allow_password_change
                 remember_created_at
                 tokens
                 integration_id]

    columns.each do |column|
      it { should have_db_column(column) }
    end

    columns_with_index = %i[account_id
                            active
                            confirmation_token
                            created_by_id
                            deleted_at
                            department_id
                            email
                            godfather_id
                            name
                            reset_password_token
                            shift_id
                            integration_id
                            updated_by_id]

    columns_with_index.each do |column|
      it { should have_db_index(column) }
    end

    it 'columns translations' do
      columns.each do |column|
        expect(I18n.exists?("activerecord.attributes.user.#{column}")).to be_truthy,
                                                                          "Column translation missing: #{column}"
      end
    end
  end

  describe 'Belongs_to associations' do
    context '' do
      subject { ::FactoryBot.create(:user, :admin) }

      it { should belong_to(:account).class_name('::Account').inverse_of(:users).with_foreign_key(:account_id).optional }
      it { should belong_to(:department).class_name('::Department').inverse_of(:users).with_foreign_key(:department_id).optional }
      it { should belong_to(:shift).class_name('::Shift').inverse_of(:users).with_foreign_key(:shift_id).optional }
      it { should belong_to(:integration).class_name('::Integration').inverse_of(:users).with_foreign_key(:integration_id).optional }
    end
  end

  describe 'Has_many associations' do
    it { should have_many(:license_plates).class_name('::LicensePlate').inverse_of(:user).with_foreign_key(:user_id) }
    it { should have_many(:emergency_contacts).class_name('::EmergencyContact').inverse_of(:user).with_foreign_key(:user_id) }
    it { should have_many(:likes).class_name('::Like').inverse_of(:user).with_foreign_key(:user_id) }
    it { should have_many(:comments).class_name('::Comment').inverse_of(:user).with_foreign_key(:user_id) }
    it { should have_many(:notifications).class_name('::Notification').inverse_of(:user).with_foreign_key(:user_id) }
    it { should have_many(:notification_tokens).class_name('::NotificationToken').inverse_of(:user).with_foreign_key(:user_id) }
  end

  describe 'Many-to-many associations associations' do
  end

  describe 'Scopes' do
    it 'list' do
      expect(::User.list).to be_an_scope_attributes
    end

    it 'show' do
      expect(::User.show).to be_an_scope_attributes
    end

    it 'autocomplete' do
      expect(::User.autocomplete).to be_an_scope_attributes
    end

    it 'birthdays' do
      start_birthday = (Date.today - 30.day).strftime('%d/%m/%Y')
      end_birthday = Date.today.strftime('%d/%m/%Y')
      expect(::User.birthdays(start_birthday, end_birthday)).to be_an_scope_attributes
    end

    it 'by_search' do
      expect(::User.by_search(::Faker::Name.name)).to be_an_scope_attributes
    end

    it 'by_name' do
      expect(::User.by_name(::Faker::Name.name)).to be_an_scope_attributes
    end

    it 'by_email' do
      expect(::User.by_email(::Faker::Internet.email)).to be_an_scope_attributes
    end

    it 'administrator' do
      expect(::User.administrators).to be_an_scope_attributes
    end

    it 'account_administrator' do
      expect(::User.account_administrator).to be_an_scope_attributes
    end

    it 'by_phone_extension' do
      expect(::User.by_phone_extension(::Faker::PhoneNumber.extension)).to be_an_scope_attributes
    end

    it 'by_license_plate' do
      expect(::User.by_license_plate(::Faker::Vehicle.license_plate)).to be_an_scope_attributes
    end

    it 'by_birthday' do
      start_birthday = (Date.today - 30.day).strftime('%d/%m/%Y')
      end_birthday = Date.today.strftime('%d/%m/%Y')
      expect(::User.by_birthday(start_birthday, end_birthday)).to be_an_scope_attributes
    end

    it 'by_department_id' do
      expect(::User.by_department_id(::Faker::Number.digit)).to be_an_scope_attributes
    end
  end

  describe 'class validations' do
    context 'normal user' do
      subject { ::FactoryBot.create(:user) }

      it { should validate_presence_of(:account) }
    end

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }
  end

  describe 'Methods' do
    it 'administrator?' do
      user = ::FactoryBot.create(:user, :admin)

      expect(user.administrator?).to be_truthy
    end
  end
end
