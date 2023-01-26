# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'Table' do
    it 'should have table name translations' do
      expect(I18n.exists?('activerecord.models.account.one')).to be_truthy, 'Column translation missing: User(:one)'
      expect(I18n.exists?('activerecord.models.account.other')).to be_truthy, 'Column translation missing: User(:other)'
    end

    columns = %i[name
                 created_by_id
                 updated_by_id
                 active
                 deleted_at
                 created_at
                 updated_at
                 smtp_user
                 smtp_password
                 smtp_host
                 smtp_email
                 users_timeout
                 timeout_in
                 imap_host
                 imap_port
                 imap_user
                 imap_password
                 imap_execution_max_time
                 imap_execution_interval_time
                 uuid]

    columns.each do |column|
      it { should have_db_column(column) }
    end

    columns_with_index = %i[active
                            cod_emp
                            created_by_id
                            deleted_at
                            name
                            updated_by_id
                            uuid]

    columns_with_index.each do |column|
      it { should have_db_index(column) }
    end

    it 'columns translations' do
      columns.each do |column|
        expect(I18n.exists?("activerecord.attributes.account.#{column}")).to be_truthy,
                                                                             "Column translation missing: #{column}"
      end
    end
  end

  describe 'ActiveStorage attachments' do
    # it 'has_one_attached :logo' do
    #   account = FactoryBot.create(:account, :with_logo)
    #
    #   expect(account.logo.attached?).to be_truthy
    # end
    #
    # it 'has_one_attached :menu_background' do
    #   account = FactoryBot.create(:account, :with_menu_background)
    #
    #   expect(account.menu_background.attached?).to be_truthy
    # end
    #
    # it 'has_one_attached :toolbar_background' do
    #   account = FactoryBot.create(:account, :with_toolbar_background)
    #
    #   expect(account.toolbar_background.attached?).to be_truthy
    # end
  end

  describe 'Belongs_to associations' do
  end

  describe 'Has_many associations' do
    it { should have_many(:users).class_name('::User').inverse_of(:account).with_foreign_key(:account_id) }
    it { should have_many(:web_services).class_name('::WebService').inverse_of(:account).with_foreign_key(:account_id) }
    it { should have_many(:departments).class_name('::Department').inverse_of(:account).with_foreign_key(:account_id) }
    it { should have_many(:groups).class_name('::Group').inverse_of(:account).with_foreign_key(:account_id) }
    it { should have_many(:spaces).class_name('::Space').inverse_of(:account).with_foreign_key(:account_id) }
    it { should have_many(:shifts).class_name('::Shift').inverse_of(:account).with_foreign_key(:account_id) }
    it { should have_many(:license_plates).class_name('::LicensePlate').inverse_of(:account).with_foreign_key(:account_id) }
    it { should have_many(:emergency_contacts).class_name('::EmergencyContact').inverse_of(:account).with_foreign_key(:account_id) }
    it { should have_many(:posts).class_name('::Post').inverse_of(:account).with_foreign_key(:account_id) }
    it { should have_many(:likes).class_name('::Like').inverse_of(:account).with_foreign_key(:account_id) }
    it { should have_many(:comments).class_name('::Comment').inverse_of(:account).with_foreign_key(:account_id) }
    it { should have_many(:birthday_cards).class_name('::BirthdayCard').inverse_of(:account).with_foreign_key(:account_id) }
    it { should have_many(:permissions).class_name('::Permission').inverse_of(:account).with_foreign_key(:account_id) }
    it { should have_many(:web_service_reports).class_name('::WebServiceReport').inverse_of(:account).with_foreign_key(:account_id) }
    it { should have_many(:notifications).class_name('::Notification').inverse_of(:account).with_foreign_key(:account_id) }
    it { should have_many(:dishes).class_name('::Dish').inverse_of(:account).with_foreign_key(:account_id) }
    it { should have_many(:meal_ratings).class_name('::MealRating').inverse_of(:account).with_foreign_key(:account_id) }
    it { should have_many(:meal_plans).class_name('::MealPlan').inverse_of(:account).with_foreign_key(:account_id) }
    it { should have_many(:meals).class_name('::Meal').inverse_of(:account).with_foreign_key(:account_id) }
    it { should have_many(:notification_tokens).class_name('::NotificationToken').inverse_of(:account).with_foreign_key(:account_id) }
    it { should have_many(:integrations).class_name('::Integration').inverse_of(:account).with_foreign_key(:account_id) }
  end

  describe 'Many-to-many associations' do
    it { should have_many(:account_tools).class_name('Many::AccountTool').inverse_of(:account).with_foreign_key(:account_id) }
  end

  describe 'Scopes' do
    it 'list' do
      expect(::Account.list).to be_an_scope_attributes
    end

    it 'show' do
      expect(::Account.show).to be_an_scope_attributes
    end

    it 'autocomplete' do
      expect(::Account.autocomplete).to be_an_scope_attributes
    end

    it 'by_name' do
      expect(::Account.by_name(::Faker::Name.name)).to be_an_scope_attributes
    end

    it 'include_images' do
      expect(::Account.include_images).to be_an_scope_attributes
    end

    it 'by_search' do
      expect(::Account.by_search(::Faker::Name.name)).to be_an_scope_attributes
    end

    it 'by_uuid' do
      expect(::Account.by_uuid(::Faker::Internet.uuid)).to be_an_scope_attributes
    end
  end

  describe 'class validations' do
    columns = %i[name
                 smtp_user
                 smtp_password
                 smtp_host
                 smtp_email
                 imap_host
                 imap_user
                 imap_password]

    columns.each do |column|
      it { should validate_length_of(column).is_at_most(255) }
    end

    it {
      should validate_numericality_of(:timeout_in)
        .only_integer
        .is_less_than_or_equal_to(9999)
        .allow_nil
    }
    it { should validate_presence_of(:name) }
  end

  describe 'Methods' do
    it 'check_uuid' do
      valid_uuid = '53b83663-c1e9-4270-80ab-752cc3bbb34e'
      valid_account = ::FactoryBot.attributes_for(:account)
      valid_account[:uuid] = valid_uuid

      account = ::Account.create(valid_account)
      expect(account.id).to be_present
    end
  end
end
