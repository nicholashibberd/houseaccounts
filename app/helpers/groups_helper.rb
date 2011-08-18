module GroupsHelper
  
  def home_top_nav_link(user)
    if request[:controller] == 'users' && request[:action] == 'show'
      link_to 'My Groups', user_path(user), :class => 'selected'
    else
      link_to 'My Groups', user_path(user)
    end
  end
  
  def group_top_nav_link(group)
    if (request[:controller] == 'groups' && params[:id].to_i == group.id) || (request[:controller] == 'members' && Member.find(params[:id].to_i).group.id == group.id)
      link_to group.name.titleize, group_path(group), :class => 'selected'
    else
      link_to group.name.titleize, group_path(group)
    end
  end
  
  def member_group_top_nav_link(member)
    if request[:controller] == 'members' && params[:id].to_i == member.id
      link_to member.name.titleize, member_path(member), :class => 'selected'
    else
      link_to member.name.titleize, member_path(member)
    end
  end

  def overview_group_top_nav_link(group)
    if request[:controller] == 'groups'
      link_to 'Overview', group_path(group), :class => 'selected'
    else
      link_to 'Overview', group_path(group)
    end
  end
  
  def group_members(group, &block)
    if group.members.size == 1
      content_tag(:div, "You are the only member in this group", :class => 'subsection')
    else
      content_tag(:div, nil, &block)
    end
  end

end
