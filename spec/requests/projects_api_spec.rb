require 'rails_helper'

RSpec.describe "Projects API", type: :request do

  it 'loads a project' do
    user = FactoryBot.create(:user)
    FactoryBot.create(:project,
      name: "Sample Project")
    FactoryBot.create(:project,
      name: "Second Sample Project",
      owner: user)

    get api_projects_path, params: {
      user_email: user.email,
      user_token: user.authentication_token
    }

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json.length).to eq 1
    project_id = json[0]["id"]

    get api_project_path(project_id), params: {
      user_email: user.email,
      user_token: user.authentication_token
    }

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json["name"]).to eq "Second Sample Project"
    # pp json # デバッグ用に整形表示
  end

  it "creates a project" do
    user = FactoryBot.create(:user)

    project_attributes = FactoryBot.attributes_for(:project)

    expect {
      post api_projects_path, params: {
        user_email: user.email,
        user_token: user.authentication_token,
        project: project_attributes
      }
    }.to change(user.projects, :count).by(1)

    expect(response).to have_http_status :success
  end

  context "updates a project" do

    it "success" do
      # idパラメータからユーザと、紐づいたプロジェクトを見つける
      user = FactoryBot.create(:user)
      project = FactoryBot.create(:project,
        name: "Project",
        owner: user)

      # updateするパラメータを作る
      project_attributes = FactoryBot.attributes_for(:project,
        id: project.id,
        name: "New API Project")

      expect {
        # 残りのパラメータをupdateする
        put api_project_path(project.id), params: {
          user_email: user.email,
          user_token: user.authentication_token,
          project: project_attributes
        }
      # パラメータが想定通りか確認する
      }.to change{ Project.find(user.id).name }.from("Project").to("New API Project")

      expect(response).to have_http_status :success
      json = JSON.parse(response.body)
      expect(json["status"]).to eq "ok"
    end

    it "failed" do
      user = FactoryBot.create(:user)
      project = FactoryBot.create(:project,
        name: "Old Project",
        owner: user)
      FactoryBot.create(:project,
        name: "Changed Project",
        owner: user)

      # updateするパラメータを作る
      project_attributes = FactoryBot.attributes_for(:project,
        id: project.id,
        name: "Changed Project")

      # 残りのパラメータをupdateする
      put api_project_path(project.id), params: {
        user_email: user.email,
        user_token: user.authentication_token,
        project: project_attributes
      }

      expect(Project.find(user.id).name).to eq "Old Project"
      expect(response).to_not have_http_status :success
      # json = JSON.parse(response.body)
      # pp json
      # expect(json["status"]).to eq "unprocessable_entity"
    end
  end
end
