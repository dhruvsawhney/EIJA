class Group < ApplicationRecord

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
  # output: Hash, key
  # : user_id, value: list of [[groupName, groupId]]
  #
  # note: groupId of -1 is for every user
  def getUserGroups
    users = User.find_by_sql("select distinct(id) from Users")
    map = Hash.new
    users.each do |userID|

      groups = Group.find_by_sql ["select groupNum, name from Groups where user_id = ?", userID]
      value = []
      for i in 0...groups.length
        inLst = []
        inLst.append(groups[i].name)
        inLst.append(groups[i].groupNum)
        value.append(inLst)
      end
      map[userID] = value
    end
    return map
  end


  # groupId does not get reset to 1 when I remove all entries but defaults to 4 if 3 deleted

  # a list of userIds
  # void: adds "" users to a new group with a new group Number

  # Ensure the GroupName is unique
  def createGroup(lst, groupName)

    gNum = -1

    # returns an array
    lastGroup = Group.find_by_sql("select * from Groups where groupNum <> -1 order by created_at DESC")

    if lastGroup.length == 0
      gNum = 1
    else
      gNum = lastGroup[0].groupNum
      gNum += 1
    end

    flag = false

    lst.each do |user|
      curr_user = Group.find_by_sql ["select * from Groups where user_id = ? and name = ?",user,groupName]
      if curr_user.length == 0
        flag = true
        Group.create(groupNum: gNum, user_id: user, name: groupName)
      end
    end

    # add the admin to all the groups
    if flag
      admin = User.first
      Group.create(groupNum: gNum, user_id: admin.id, name: groupName)
    end
  end

  # remove a group that has a number in the db
  def removeGroup(number)
    # remove all users that are in the same group
    Group.where(groupNum: number).delete_all
  end

  # remove a single user from a single group
  # input: userID
  def removeUserGroup(uId, gId)
    Group.where(groupNum: gId).where(userId: uId).delete_all
  end

end
