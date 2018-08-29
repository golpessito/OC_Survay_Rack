require 'sanitize'

class View

  attr_accessor :data,:page,:template

  def initialize(page, data={})
    @data=data
    @page=page
    redirect_page(page)
  end

  def redirect_page(page)
    #Create the full path (independent of the O.S)
    directory=File.join(File.dirname(__FILE__), "./templates/#{page}.html.erb")
    file=File.join(File.dirname(__FILE__), "./templates/#{page}.html.erb")
    @template=File.read(file)
  end

  def render
    ERB.new(@template).result(binding)
  end

end
