class UsersRepresenter
  def initialize(users)
    @users = users
  end

  def as_json
    users.map do |user|
      {
        id: user.id,
        name: user.name,
        balance: user.balance,
      }
    end
  end

  private

  attr_reader :users
end