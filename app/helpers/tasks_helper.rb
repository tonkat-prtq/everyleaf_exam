module TasksHelper
  def sort_th(th_name,cont_name)
    if request.fullpath.include?('desc')
      link_to th_name, sort: cont_name
    else
      link_to th_name, sort: "#{cont_name} desc"
    end
  end
end