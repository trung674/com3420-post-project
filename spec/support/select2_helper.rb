module Select2Helper
  def select2(value, options = {})
    raise "Must pass a hash containing 'from' or 'xpath'" unless options.is_a?(Hash) and [:from, :xpath].any? { |k| options.has_key? k }

    if options.has_key? :xpath
      select2_container = first(:xpath, options[:xpath])
    else
      select_name = options[:from]
      select2_container = first("label", text: select_name).find(:xpath, '..').find(".select2-container")
    end

    select2_container.find(".select2-choice, .select2-choices").click

    [value].flatten.each do |value|
      select2_container.find(:xpath, "a[contains(concat(' ',normalize-space(@class),' '),' select2-choice ')] | ul[contains(concat(' ',normalize-space(@class),' '),' select2-choices ')]").trigger('click')
      find(:xpath, "//body").find(".select2-drop li", text: value).click
    end
  end
end