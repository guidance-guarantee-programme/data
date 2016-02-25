require 'date'
module RawDataLoaders
  def raw_data(name)
    path = "#{__dir__}/../fixtures/#{name}.json"
    JSON.parse(
      File.read(path)
    )
  end
end
