require "spec_helper"
require "signup"

describe Signup do
  describe "#save" do
    it "creates an account with one user" do
      email        = "user@example.com"
      account_name = "Example"
      account      = double("example_account", name: account_name)

      mock_account_creation_with(account, account_name)
      mock_user_creation_with(account, email)

      signup = Signup.new(email: email, account_name: account_name)
      result = signup.save

      expect(result).to be(true)
    end
  end

  describe "#user" do
    it "returns the user created by #save" do
      email        = "user@example.com"
      account_name = "Example"
      account      = double("example_account", name: account_name)
      user         = double("user", email: email, account: account)

      mock_account_creation_with(account, account_name)
      mock_user_creation_with(account, email).and_return(user)

      signup = Signup.new(email: email, account_name: account_name)
      signup.save

      result = signup.user

      expect(result.email).to eq("user@example.com")
      expect(result.account.name).to eq("Example")
    end
  end

  def mock_account_creation_with(account, account_name)
    expect(Account).to receive(:create!)
      .with(name: account_name)
      .and_return(account)
  end

  def mock_user_creation_with(account, email)
    expect(User).to receive(:create!)
      .with(account: account, email: email)
  end
end
