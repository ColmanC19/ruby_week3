class Volunteer
  attr_reader :name, :id
  # attr_accessor :name

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def save
    result = DB.exec("INSERT INTO volunteers (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  # def update(name)
  #   @name = name
  #   DB.exec("UPDATE volunteers SET name = '#{@name}' WHERE id = #{@id};")
  # end

  def ==(volunteer_to_compare)
    self.name() == volunteer_to_compare.name()
  end

  def self.all
    returned_volunteers = DB.exec("SELECT * FROM volunteers;")
    volunteers = []
    returned_volunteers.each do |volunteer|
      name = volunteer.fetch "name"
      id = volunteer.fetch("id").to_i
      volunteers.push(Volunteer.new({:name => name, :id => id}))
    end
    volunteers
  end

  def self.clear
    DB.exec("DELETE FROM volunteers *;")
  end

  def self.sort
    self.get_volunteers("SELECT * FROM volunteers ORDER BY lower(name);")
    # @projects.values.sort {|a, b| a.name.downcase <=> b.name.downcase}
  end

  # def update(attributes)
  #   if (attributes.is_a? String)
  #     @name = attributes
  #     DB.exec("UPDATE volunteers SET name = '#{@name}' WHERE id = #{@id};")
  #   else
  #     project_name = attributes.fetch(:project_name)
  #     if project_name != nil
  #       project = DB.exec("SELECT * FROM projects WHERE lower(title)='#{project_name.downcase}';").first
  #       if project != nil
  #         DB.exec("INSERT INTO volunteers_projects (projects_id, volunteers_id) VALUES (#{project['id'].to_i}, #{@id});")
  #       end
  #     end
  #   end
  # end

  def update(attributes)
    @name = attributes.fetch(:name)
    @id = self.id
    DB.exec("UPDATE volunteers SET name = '#{@name}' WHERE id = #{@id};")
  #   if (attributes.is_a? String)
  #     @name = attributes
  #     DB.exec("UPDATE volunteers SET name = '#{@name}' WHERE id = #{@id};")
  #   else
  #     project_name = attributes.fetch(:project_name)
  #     if project_name != nil
  #       project = DB.exec("SELECT * FROM projects WHERE lower(title)='#{project_name.downcase}';").first
  #       if project != nil
  #         DB.exec("INSERT INTO volunteers_projects (projects_id, volunteers_id) VALUES (#{project['id'].to_i}, #{@id});")
  #       end
  #     end
  #   end
  # end

  def self.find(id)
    returned_volunteer = nil
    Volunteer.all.each do |volunteer|
      if volunteer.id == id
        returned_volunteer = volunteer
      end
    end
    returned_volunteer
  end

  def delete
    # DB.exec("DELETE FROM volunteers_projects WHERE volunteers_id = #{@id};")
    DB.exec("DELETE FROM volunteers WHERE id = #{@id};")
  end

  def projects
  projects = []
  results = DB.exec("SELECT projects_id FROM volunteers_projects WHERE volunteers_id = #{@id};")
    results.each() do |result|
      projects_id = result.fetch("projects_id").to_i()
      project = DB.exec("SELECT * FROM projects WHERE id = #{projects_id};")
binding.pry
      title = project.fetch("title")
      projects.push(Book.new({:title => title, :id => projects_id}))
    end
    projects
  end
    # id_string = results.first.fetch("projects_id").to_i()
    # (id_string != '') ? Book.get_projects("SELECT * FROM projects where ID in (#{id_string});") : []



  # results.each() do |result|
  #   project_id = result.fetch("project_id").to_i()
  #   project = DB.exec("SELECT * FROM projects WHERE id = #{project_id};").first()
  #   name = project.fetch("name").join(', ')
  #   release_year = project.fetch("release_year")
  #   genre = project.fetch("genre")
  #   volunteer = project.fetch("volunteer")
  #   projects.push(Album.new({:name => name, :id => project_id, :release_year => release_year, :genre => genre, :volunteer => volunteer}))
  # end
  # projects


def self.get_volunteers(query)
  returned_volunteers = DB.exec(query)
  volunteers = []
  returned_volunteers.each() do |volunteer|
    name = volunteer.fetch("name")
    id = volunteer.fetch("id").to_i
    volunteers.push(Volunteer.new({:name => name, :id => id}))
  end
  volunteers
end

def self.search(x)
  self.get_volunteers("SELECT * FROM volunteers WHERE name ILIKE '%#{x}%'")
  # @projects.values.select { |e| /#{x}/i.match? e.name}
end
end
end
