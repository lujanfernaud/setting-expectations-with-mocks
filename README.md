# Upcase: Test Doubles

## Setting Expectations with Mocks

Setting expectations with mocks for the [Test Doubles](https://thoughtbot.com/upcase/test-doubles) course.

### Before

```ruby
# signup_spec.rb

describe Signup do
  describe "#save" do
    it "creates an account with one user" do
      signup = Signup.new(email: "user@example.com", account_name: "Example")

      result = signup.save

      expect(Account.count).to eq(1)
      expect(Account.last.name).to eq("Example")
      expect(User.count).to eq(1)
      expect(User.last.email).to eq("user@example.com")
      expect(User.last.account).to eq(Account.last)
      expect(result).to be(true)
    end
  end

  describe "#user" do
    it "returns the user created by #save" do
      signup = Signup.new(email: "user@example.com", account_name: "Example")
      signup.save

      result = signup.user

      expect(result.email).to eq("user@example.com")
      expect(result.account.name).to eq("Example")
    end
  end
end
```

### After

```ruby
# signup_spec.rb

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
```
