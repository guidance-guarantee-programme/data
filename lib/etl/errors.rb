module ETL
  module Errors
    def log_errors(log)
      yield
    rescue => e
      error_description = [e.class.to_s, e.message].uniq.compact.join(': ')
      log[error_description] += 1
      nil
    end
  end
end
