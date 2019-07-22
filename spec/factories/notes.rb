FactoryBot.define do
  factory :note do
    message "My important note."
    association :project
    user { project.owner }

    # ファイルが最初から添付された新しいNoteオブジェクトを作成するための記述
    trait :with_attachment do
      attachment { File.new("#{Rails.root}/spec/files/everydayrailsrspec-jp.pdf") }
    end
  end
end
