# rubocop:disable all
class ContractDataService
  def contract_list(order_field, direction, organization_ids, current_staff_id, filter_params)
    filter_cond = []

    # Default filter
    # filter_cond << "steps.field_name IN ('tele_evaluate', 'reference_evaluate', 'business_evaluate', 'property_evaluate')"
    filter_cond << 'contracts.deleted_at IS NULL'
    filter_cond << "(people.organization_id IN (#{organization_ids.join(',')})
                   OR people.owner_id = #{current_staff_id}
                   OR ps.assigned_staff_id = #{current_staff_id})"

    # Filter values
    if filter_params
      filter_cond << "contracts.id = #{filter_params[:id].to_i}" unless filter_params[:id].blank?
      filter_cond << "CONCAT(people.last_name, people.first_name) LIKE '%#{filter_params[:full_name]}%'" unless filter_params[:full_name].blank?
      filter_cond << "contracts.status = #{filter_params[:status].to_i}" unless filter_params[:status].blank?
      filter_cond << "people.organization_id = #{filter_params[:organization_id].to_i}" unless filter_params[:organization_id].blank?
      filter_cond << "LOWER(staffs.name) LIKE LOWER('%#{filter_params[:tele_evaluate]}%')" unless filter_params[:tele_evaluate].blank?
      filter_cond << "LOWER(staffs.name) LIKE LOWER('%#{filter_params[:reference_evaluate]}%')" unless filter_params[:reference_evaluate].blank?
      filter_cond << "LOWER(staffs.name) LIKE LOWER('%#{filter_params[:business_evaluate]}%')" unless filter_params[:business_evaluate].blank?
      filter_cond << "LOWER(staffs.name) LIKE LOWER('%#{filter_params[:property_evaluate]}%')" unless filter_params[:property_evaluate].blank?
    end

    # Sort field
    order_cond = case order_field
                 when 'id', 'status'
                    "contracts.#{order_field} #{direction}"
                 when 'full_name'
                    "people.first_name || ' ' || people.last_name #{direction}"
                 when 'organization_id'
                    "organizations.name #{direction}"
                 else
                    "contracts.status ASC"
                 end

    query = "SELECT
                contracts.*
            FROM
                contracts
                INNER JOIN people ON contracts.person_id = people.id
                INNER JOIN people_steps AS ps ON ps.contract_id = contracts.id
                INNER JOIN organizations ON people.organization_id = organizations.id
                INNER JOIN steps ON ps.step_id = steps.id
                INNER JOIN staffs ON ps.assigned_staff_id = staffs.id
            WHERE
                #{filter_cond.join(' AND ')}
            ORDER BY
                #{order_cond}"
                puts query
    _results = Contract.find_by_sql(query).uniq
  end
end
