require 'rails_helper'

RSpec.feature "Sign in", type: :feature do
  let(:user) { FactoryBot.create(:user) }

  # ActiveJobマッチャを使うための設定
  before do
    ActiveJob::Base.queue_adapter = :test
  end

  scenario "user signs in" do
    visit root_path
    click_link "Sign In"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    # have_enqueued_jobはブロック形式のエクスペクテーションのみサポートする
    expect {
      GeocodeUserJob.perform_later(user)
    }.to have_enqueued_job.with(user)
  end
end
