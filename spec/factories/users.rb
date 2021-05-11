FactoryBot.define do
  factory :user do
    # name {'Test User'}
    sequence(:email) {|i| "user#{i}@example.com"}
    password {'liberty'}
    password_confirmation {'liberty'}

    after(:build) do |u|
      #u.account ||= build(:account, owner: u)
    end

    after(:create) do |u|
      u.reload
    end

    factory :student_user do
      after(:build) do |u|
        u.role = User::Role::STUDENT
      end
    end

    factory :teacher_user do
      after(:build) do |u|
        u.role = User::Role::TEACHER
      end
    end
    factory :admin_user do
      after(:build) do |u|
        u.role = User::Role::ADMIN
      end
    end

  end
end