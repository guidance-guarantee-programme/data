module BookingBug
  class Base
    # Allow subset of actions to be run by specifying the number of actions to be performed.
    # Defaults to all actions
    def call(actions_to_perform: actions.count)
      actions[0..actions_to_perform - 1].inject(records: [], log: Hash.new(0)) do |data, action|
        action.call(data)
      end
    end

    # Each 'action' is implemented with an interface which take an input of:
    #   { records: <Array>, errors: Hash.new(0) }
    # and returns a hash in the same format.
    def actions
      raise ImplementInClass
    end

    def build_audit_dimension(fact_table)
      Dimensions::Audit.create(
        fact_table: fact_table,
        source: 'BookingBug',
        source_type: 'api'
      )
    end
  end
end
