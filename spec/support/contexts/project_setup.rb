RSpec.shared_context "project setup" do
	let(:user) { FactoryBot.create(:user) }
	let(:project) { FactoryBot.create(:project, owner: user) }
	# model作成の時点で失敗したら例外終了させたいので、create!を使う
	let(:task) { project.tasks.create!(name: "Test task") }
end