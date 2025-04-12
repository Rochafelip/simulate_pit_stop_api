require 'rails_helper'

RSpec.describe User, type: :model do
  it "valida um usuário com email e senha" do
    user = User.new(email: "test@example.com", password: "123456")
    expect(user).to be_valid
  end
end
