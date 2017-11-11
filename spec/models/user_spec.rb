require "rails_helper"

RSpec.describe User, :type => :model do
  it "blank password" do
    user = User.create!(user_name: "nhan", password: '', name: "test password")
    expect(user).to have(1).errors_on(:password)
  end
 
  it "has none to begin with" do
    expect(User.count).to eq 0
  end
 
  it "has one record" do
    user = User.create!(user_name: "nhan", password: '123456', name: "test password")
    expect(User.count).to eq 1
  end

  it "has two record" do
    user = User.create!(user_name: "nhan", password: '123456', name: "test password")
    expect(User.count).to eq 2
  end

  it "duplicate unique prime key" do
    userA = User.create!(user_name: "nhan", password: '123456', name: "Lindeman")
    userB = User.create!(user_name: "nhan", password: '654321', name: "Chelimsky")

    expect(userB).to have(1).errors_on(:user_name)
  end
end
