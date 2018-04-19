class User < ApplicationRecord

  # a call-back after User object initialization via registrations_controller
  after_create :addUserGroupRelation

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def addUserGroupRelation
    group_record = Group.create(groupNum: -1, user_id: self.id)
    User.update(self.id, :groups_id => group_record.id)
  end

  # list all active groups (that are not singleton users)
  # output: a LOL where the first element is the groupName and the second element is the groupNumber
  def getGroups
    # -1 is the default for single users
    lst = Group.find_by_sql("select * from Groups where groupNum <> -1")
    result = []
    for i in 0...lst.length
      inLst = []
      inLst[0] = lst[i].name
      inLst[1] = lst[i].groupNum
      result.append(inLst)
    end
    return result
  end

  # list all groups a user is part of
  # output: Hash, key: user_id, value: list of [[groupName, groupNum, groupId]]
  #
  # note: groupId of -1 is for every user
  def getUserGroups(userID)
    map = Hash.new

      groups = Group.find_by_sql ["select groupNum, name from Groups where user_id = ?", userID]
      value = []
      for i in 0...groups.length
        inLst = []
        inLst.append(groups[i].name)
        inLst.append(groups[i].groupNum)
        value.append(inLst)
      end
      return value
  end


  # output: a lol, first elem: user_id, second elem: user_name
  def getAllUsers

    active_users = []

    users = User.all
    users.each do |usr|
      # admin
      if usr.id != 1
        lst = [usr.id,usr.user_name]
        active_users.append(lst)
      end
    end
    return active_users
  end

end
