class AddAuditDimensionToFactsAppointment < ActiveRecord::Migration
  def change
    add_reference :facts_appointments, :dimensions_audit
  end
end
