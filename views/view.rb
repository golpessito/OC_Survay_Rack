require 'sanitize'

class View

  def initialize(page, data={})
    @data=data
    @page=page

    #Create the full path (independent of the O.S)
    file=File.join(File.dirname(__FILE__), "./templates/#{page}.html.erb")
    @template=File.read(file)
  end

  def render
    ERB.new(@template).result(binding)
  end

end
