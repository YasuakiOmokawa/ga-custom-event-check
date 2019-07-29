require 'rails_helper'

RSpec.describe User, type: :model do

  describe "with factory bot" do

    context "when it first build" do
      it { is_expected.to validate_presence_of :first_name }
      it { is_expected.to validate_presence_of :last_name }
      it { is_expected.to validate_presence_of :email }
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end

    context "when it after build" do

      it "returns a user's full name as a string" do
        user = FactoryBot.build(:user, first_name: "John", last_name: "Doe")
        expect(user.name).to eq "John Doe"
      end

      it "has a weak password" do
        user = FactoryBot.build(:user, :weak_password)
        expect(user.password).to eq "hoge"
      end

      it "has a normal password" do
        user = FactoryBot.build(:user)
        expect(user.password).to_not eq "hoge"
      end
    end

    context "when it build after one" do

      it "is invalid with a duplicate email address" do
        FactoryBot.create(:user, email: "aaron@example.com")
        user = FactoryBot.build(:user, email: "aaron@example.com")
        user.valid?
        expect(user.errors[:email]).to include "has already been taken"
      end
    end

    it "sends a welcome email on account creation" do
      allow(UserMailer).to \
        receive_message_chain(:welcome_email, :deliver_later)
      user = FactoryBot.create(:user)
      expect(UserMailer).to have_received(:welcome_email).with(user)
    end

    it "performs geocoding", vcr: true do
      user = FactoryBot.create(:user, last_sign_in_ip: "161.185.207.20")
      expect {
        user.geocode
      }.to change(user, :location).
        from(nil).
        to("Brooklyn, New York, US")
    end
  end
end
