module TasksHelper
  def sort_th_desc(th_name,cont_name)
    if request.fullpath.include?('desc')
      link_to th_name, sort: cont_name
    else
      link_to th_name, sort: "#{cont_name} desc"
    end
  end

  def sort_th_asc(th_name,cont_name)
    if request.fullpath.include?('asc')
      link_to th_name, sort: "#{cont_name} desc"
    else
      link_to th_name, sort: "#{cont_name} asc"
    end
  end
end