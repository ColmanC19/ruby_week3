class Project
  attr_reader :name, :id

  def initialize(attributes)
    @name = attributes.fetch :name
    @id = attributes.fetch :id
  end

  def self.all
    returned_projects = DB.exec("SELECT * FROM projects;")
    projects = []
    returned_projects.each do |project|
      name = project.fetch "name"
      id = project.fetch("id").to_i
      projects.push(Project.new({:name => name, :id => id}))
    end
    projects
  end

  def save
    result = DB.exec("INSERT INTO projects (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  def ==(another_project)
    (self.name == another_project.name) & (self.id == another_project.id)
  end


  def self.find(id)
    found_project = nil
    Project.all.each do |project|
      if project.id == id
        found_project = project
      end
    end
    found_project
  end

  def delete
    DB.exec("DELETE FROM projects WHERE id = #{self.id};")
    DB.exec("DELETE FROM volunteers WHERE project_id = #{self.id};")
  end

  def update(attributes)
    @name = attributes.fetch :name
    @id = self.id
    DB.exec("UPDATE projects SET name = '#{@name}' WHERE id = #{@id};")
  end

  def volunteers
    project_volunteers = []
    volunteers = DB.exec("SELECT * FROM volunteers WHERE project_id = #{self.id};")
    volunteers.each do |volunteer|
      name = volunteer.fetch "name"
      id = volunteer.fetch("id").to_i
      project_volunteers.push(Volunteer.new({:name => name, :id => id}))
    end
    project_volunteers
  end

  def hours
    DB.exec("SELECT SUM(hours) FROM volunteers WHERE project_id = #{self.id};")
  end

  def self.project_search(query)
    found_projects = DB.exec("SELECT * FROM projects WHERE name LIKE '%#{query}%';")
    projects = []
    found_projects.each() do |project|
      name = project.fetch('name')
      id = project.fetch('id').to_i
      projects.push(Project.new({:name => name, :id => id}))
    end
    projects
  end

  def self.order
    DB.exec("SELECT * FROM projects ORDER BY name").to_a
  end

  def self.order_hours
    projects = Project.all
    projects.each do |project|
      project.hours[0]["sum"]
    end
    projects.sort!
  end

end
# class Project
#   attr_reader :name, :id
#
#   def initialize(attributes)
#     @name = attributes.fetch :name
#     @id = attributes.fetch :id
#   end
#
#   def self.all
#     returned_projects = DB.exec("SELECT * FROM projects;")
#     projects = []
#     returned_projects.each do |project|
#       name = project.fetch "name"
#       id = project.fetch("id").to_i
#       projects.push(Project.new({:name => name, :id => id}))
#     end
#     projects
#   end
#
#   def save
#     result = DB.exec("INSERT INTO projects (name) VALUES ('#{@name}') RETURNING id;")
#     @id = result.first.fetch("id").to_i
#   end
#
#   def ==(another_project)
#     (self.name == another_project.name) & (self.id == another_project.id)
#   end
#
#
#   def self.find(id)
#     found_project = nil
#     Project.all.each do |project|
#       if project.id == id
#         found_project = project
#       end
#     end
#     found_project
#   end
#
#   def delete
#     DB.exec("DELETE FROM projects WHERE id = #{self.id};")
#     DB.exec("DELETE FROM volunteers WHERE project_id = #{self.id};")
#   end
#
#   def update(attributes)
#     @name = attributes.fetch :name
#     @id = self.id
#     DB.exec("UPDATE projects SET name = '#{@name}' WHERE id = #{@id};")
#   end
#
#   def volunteers
#     project_volunteers = []
#     volunteers = DB.exec("SELECT * FROM volunteers WHERE project_id = #{self.id};")
#     volunteers.each do |volunteer|
#       name = volunteer.fetch "name"
#       id = volunteer.fetch("id").to_i
#       project_volunteers.push(Volunteer.new({:name => name, :id => id}))
#     end
#     project_volunteers
#   end
#
#   def hours
#     DB.exec("SELECT SUM(hours) FROM volunteers WHERE project_id = #{self.id};")
#   end
#
#   def self.project_search(query)
#     found_projects = DB.exec("SELECT * FROM projects WHERE name LIKE '%#{query}%';")
#     projects = []
#     found_projects.each() do |project|
#       name = project.fetch('name')
#       id = project.fetch('id').to_i
#       projects.push(Project.new({:name => name, :id => id}))
#     end
#     projects
#   end
#
#   def self.order
#     DB.exec("SELECT * FROM projects ORDER BY name").to_a
#   end
#
#   def self.order_hours
#     projects = Project.all
#     projects.each do |project|
#       project.hours[0]["sum"]
#     end
#     projects.sort!
#   end
#
# end

# class Project
#   attr_accessor :title, :id
#
#   def initialize(attributes)
#     @title = attributes.fetch(:title)
#     @id = attributes.fetch(:id)
#
#   end
#
#   def save
#     result = DB.exec("INSERT INTO projects (title) VALUES ('#{@title}') RETURNING id;")
#     @id = result.first().fetch("id").to_i
#   end
#
#   def update(title)
#     @title = title || @title
#     DB.exec("UPDATE projects SET title = '#{@title}' WHERE id = #{@id};")
#   end
#
#   def ==(project_to_compare)
#     self.title() == project_to_compare.title()
#   end
#
#   def self.all
#     self.get_projects("SELECT * FROM projects;")
#   end
#
#   def self.clear
#     DB.exec("DELETE FROM projects *;")
#   end
#
#   def self.find(id)
#     project = DB.exec("SELECT * FROM projects WHERE id = #{id};").first
#     title = project.fetch("title")
#     id = project.fetch("id").to_i
#     Book.new({:title => title, :id => id})
#   end
#
#   def self.get_projects(query)
#     returned_projects = DB.exec(query)
#     projects = []
#     returned_projects.each() do |project|
#       title = project.fetch("title")
#       id = project.fetch("id").to_i
#       projects.push(Book.new({:title => title, :id => id}))
#     end
#     projects
#   end
#
#   def delete
#     DB.exec("DELETE FROM projects WHERE id = #{@id};")
#   end
#
#   def self.sort
#     self.get_projects("SELECT * FROM projects ORDER BY lower(title);")
#     # @projects.values.sort {|a, b| a.name.downcase <=> b.name.downcase}
#   end
#
#   def self.search(x)
#     self.get_projects("SELECT * FROM projects WHERE title ILIKE '%#{x}%'")
#     # @projects.values.select { |e| /#{x}/i.match? e.name}
#   end
# end
