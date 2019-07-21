require 'rails_helper'

RSpec.describe NotesController, type: :controller do

  let(:user) { double("user") }
  # 後続の記述でownerとid属性を使うので、instance_doubleを使ってバリデーションしている
  let(:project) { instance_double("Project", owner: user, id: "123") }

  # パスワード認証が求められる箇所と、データベースアクセスが実施される箇所をテストダブルを
  # 返却するように変更
  before do
    allow(request.env["warden"]).to receive(:authenticate!).and_return(user)
    allow(controller).to receive(:current_user).and_return(user)
    allow(Project).to receive(:find).with("123").and_return(project)
  end

  describe "#index" do

    it "searches notes by the provided keyword" do
      # projectに関連するnotesが持つsearchスコープが呼ばれることと、
      # その際の検索キーワードであるtermが同名のパラメータ値に一致することを検証。
      # エクスペクテーションはアプリコードを動かす前に書かないといけない。
      expect(project).to receive_message_chain(:notes, :search).
        with("rotate tires")

      get :index,
        params: { project_id: project.id, term: "rotate tires" }
    end
  end
end
