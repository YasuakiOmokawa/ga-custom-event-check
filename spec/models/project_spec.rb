require 'rails_helper'

RSpec.describe Project, type: :model do

  describe "validation" do

    context "when it build" do

			it { is_expected.to validate_presence_of(:name) }
			it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }
		end
	end

	describe "late status" do

		it "is late when the due date is past today" do
			project = FactoryBot.create(:project, :due_yesterday)
			expect(project).to be_late
		end

		it "is on time when the due date is today" do
			project = FactoryBot.create :project, :due_today
			expect(project).to_not be_late
		end

		it "is on time when the due date is in the future" do
			project = FactoryBot.create :project, :due_tomorrow
			expect(project).to_not be_late
		end

		it "can have many notes" do
			project = FactoryBot.create(:project, :with_notes)
			expect(project.notes.length).to eq 5
		end
	end
end