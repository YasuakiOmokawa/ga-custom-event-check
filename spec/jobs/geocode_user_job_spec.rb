require 'rails_helper'

RSpec.describe GeocodeUserJob, type: :job do

  it "calls geocode on the user" do

    # テスト用モックの作成
    user = instance_double("User")

    # モックユーザに対してgeocodeメソッドが呼び出されることをRSpecに伝える
    expect(user).to receive(:geocode)

    # バックグラウンドジョブ自体を呼び出す。
    # こうすると、ジョブはキューに入らず、テストの実行結果をすぐに検証できる。
    GeocodeUserJob.perform_now(user)
  end
end
