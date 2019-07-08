require 'rails_helper'

RSpec.feature "Projects", type: :feature do

	let(:user) { FactoryBot.create(:user) }

  scenario "user creates a new project" do
  	sign_in user # Deviseのヘルパーメソッド
  	go_to_project "New Project"

		create_project "Test Project"
		expect_create_project "Test Project"
	end

  scenario "user updates a project" do
  	project = FactoryBot.create(:project, owner: user)

  	sign_in user # Deviseのヘルパーメソッド
  	go_to_project project.name

		update_project "Update Description"
		expect_update_project "Update Description"
	end

	def go_to_project(name)
  	visit root_path # Deviseのsign_inではセッションを作成するだけなので、遷移を行う
  	click_link name
	end

	def create_project(name)
  	expect {
  		fill_in "Name", with: name
  		fill_in "Description", with: "Trying out Capybara"
  		click_button "Create Project"
  	}.to change(user.projects, :count).by(1)
	end

	def update_project(content)
  	click_link "Edit"
  	fill_in "Description", with: content
  	click_button "Update Project"
	end

	def expect_create_project(name)
		aggregate_failures do
			expect(page).to have_content "Project was successfully created"
			expect(page).to have_content name
			expect(page).to have_content "Owner: #{user.name}"
		end
	end

	def expect_update_project(content)
		aggregate_failures do
			expect(page).to have_content "Project was successfully updated"
			expect(page).to have_content content
		end
	end
end
