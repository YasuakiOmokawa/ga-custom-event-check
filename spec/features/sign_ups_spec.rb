require 'rails_helper'

RSpec.feature "Sign-ups", type: :feature do
  # ActiveJobマッチャを使うための設定
  include ActiveJob::TestHelper

  scenario "user successfully signs up" do
    visit root_path
    click_link "Sign up"

    # メールはバックグラウンドプロセスで送信されるため、
    # perform_enqueued_jobsで囲む必要がある。
    # このヘルパーメソッドは、ActiveJob::TestHelperが提供している。
    perform_enqueued_jobs do
      expect {
        fill_in "First name", with: "First"
        fill_in "Last name", with: "Last"
        fill_in "Email", with: "test@example.com"
        fill_in "Password", with:"test123"
        fill_in "Password confirmation", with: "test123"
        click_button "Sign up"
      }.to change(User, :count).by(1)

      expect(page).to \
        have_content "Welcome! You have signed up successfully."
      expect(current_path).to eq root_path
      expect(page).to have_content "First Last"
    end

    # 上記で追加されたメールキューから最新のメールを取得
    mail = ActionMailer::Base.deliveries.last

    aggregate_failures do
      expect(mail.to).to eq ["test@example.com"]
      expect(mail.from).to eq ["support@example.com"]
      expect(mail.subject).to eq "Welcome to Projects!"
      expect(mail.body).to match "Hello First,"
      expect(mail.body).to match "test@example.com"
    end
  end
end
