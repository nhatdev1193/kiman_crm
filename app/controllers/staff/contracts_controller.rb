class Staff::ContractsController < Staff::BaseController
  def index
    @condition_params = request.query_parameters

    order_field = params[:sort]
    direction = params[:direction]
    organization_ids = current_staff.highest_organization.all_children
    filter_params = params[:s]

    service = ContractDataService.new
    @contracts = service.contract_list(order_field, direction, organization_ids, current_staff.id, filter_params)
                        .paginate(page: params[:page], per_page: params[:per_page])
  end
end
