module Admin::ProjectTypesHelper
  
  def select_dashboard( object, method )
    list = ProjectType.dashboard_list.collect{|i|[i,i]}
    return select( object, method, list,{},:class=> 'x-form-select x-form-field')
  end
  
end
