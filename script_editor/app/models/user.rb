class User < ApplicationRecord

  # a call-back after User object initialization via registrations_controller
  after_create :addUserGroupRelation

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # adds users into groups of size 1 with a group_number of -1
  # all users have an individual -1 group
  # this allows users to make edits as individual users
  def addUserGroupRelation
    group_record = Group.create(groupNum: -1, user_id: self.id)
    User.update(self.id, :groups_id => group_record.id)
  end

  # list all active groups (that are not singleton users (of groupNum -1))
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
        lst = [usr.id, usr.user_name]
        active_users.append(lst)
      end
    end
    return active_users
  end

  #output: map, Key: GroupName, value: lol of user_id and user_name
  def getUsersFromGroups
    groups = Group.find_by_sql("select distinct(name), groupNum from Groups where name <> '' order by name ")

    map = Hash.new

    groups.each do |g|
      members = Group.find_by_sql ["select * from Groups where name = ? and user_id <> 1", g.name]
      lol = []
      members.each do |m|
        lst = []
        lst.append(m.user_id)
        # BUG ALERT :: user_id is 0 at times that causes a server error
        # skip the iteration that breaks the loop
        # needs investigation
        if m.user_id == 0
          next
        end
        name = User.find(m.user_id).user_name
        lst.append(name)
        lst.append(g.groupNum)
        lol.append(lst)
      end
      map[g.name] = lol
    end
    return map
  end

  # Map, key: groupName, value: [[group_num, play_name, play_id]]
  def getplaysFromGroups
    map = Hash.new

    groups = Group.find_by_sql("select distinct(name), groupNum from Groups where name <> '' order by name ")

    groups.each do |g|
      members = Group.find_by_sql ["select * from Groups where name = ? and user_id <> 1", g.name]
      set = Set.new

      members.each do |m|
        edits = Edit.find_by_sql ["select * from Edits where user_id = ?", m.user_id]

        edits.each do |edit|
          groupNum = Group.find(edit.groups_id).groupNum

          if g.groupNum == groupNum # the edit was made as part of the current group
            set.add(edit.play_id)
          end
        end
      end

      lol = []

      set.each do |num|
        lst = []
        lst.append(g.groupNum)
        lst.append(Play.find(num).title)
        lst.append(num)
        lol.append(lst)
      end

      map[g.name] = lol
    end

    return map
  end
end
