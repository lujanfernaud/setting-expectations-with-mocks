require "spec_helper"
require "signup"

describe Signup do
  describe "#save" do
    it "creates an account with one user" do
      email   = "user@example.com"
      account = double("account", name: "Example")

      mock_account_creation_with(account)
      mock_user_creation_with(account, email)

      signup = Signup.new(email: email, account_name: account.name)
      result = signup.save

      expect(result).to be(true)
    end
  end

  describe "#user" do
    it "returns the user created by #save" do
      email   = "user@example.com"
      account = double("account", name: "Example")
      user    = double("user", email: email, account: account)

      mock_account_creation_with(account)
      mock_user_creation_with(account, email).and_return(user)

      signup = Signup.new(email: email, account_name: account.name)
      signup.save

      result = signup.user

      expect(result.email).to eq("user@example.com")
      expect(result.account.name).to eq("Example")
    end
  end

  def mock_account_creation_with(account)
    expect(Account).to receive(:create!)
      .with(name: account.name)
      .and_return(account)
  end

  def mock_user_creation_with(account, email)
    expect(User).to receive(:create!)
      .with(account: account, email: email)
  end
end
