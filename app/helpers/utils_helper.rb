module UtilsHelper
  def build_array_by_key(array, key)
    return {} if array.blank?
    result = {}
    array.each do |item|
      result[item[key]] = item[key] if item.has_key?(key)
    end
    result
  end

end
