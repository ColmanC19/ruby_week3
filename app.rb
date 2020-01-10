require('sinatra')
require('sinatra/reloader')
require('./lib/project')
require('pry')
also_reload('lib/**/*.rb')
require('./lib/volunteer')
require("pg")

DB =PG.connect({:dbname => "ruby_week3"})

get('/') do
  @projects = Project.all
  erb(:projects)
end

get('/projects') do
  if params["clear"]
    @projects = Project.clear()
  elsif params["search_input"]
    @projects = Project.search(params["search_input"])
  elsif params["sort_list"]
    @projects = Project.sort()

  else
    @projects = Project.all
  end
  erb(:projects)
end

get('/projects/new') do
  erb(:new_project)
end

post('/projects') do
  title = params[:title]
  project = Project.new(:title => title, :id => nil)
  project.save()
  @projects = Project.all()
  erb(:projects)
end

get('/projects/:id') do
  @project = Project.find(params[:id].to_i())
  erb(:project)
end

get('/projects/:id/edit') do
@project = Project.find(params[:id].to_i())
erb(:edit_project)
end

patch('/projects/:id') do
@project  = Project.find(params[:id].to_i())
@project.update(params[:title])
@projects = Project.all
erb(:projects)
end

delete('/projects/:id') do
  @project = Project.find(params[:id].to_i())
  @project.delete()
  @projects = Project.all
  erb(:projects)
end

#Volunteers Routing¡! - -- - -- - - - - - - - >

get('/volunteers/new') do
  erb(:new_volunteer)
end

get('/volunteers') do
  if params["clear"]
    @volunteers = Volunteer.clear()
  elsif params["search_input"]
    @volunteers = Volunteer.search(params["search_input"])
  elsif params["sort_list"]
    @volunteers = Volunteer.sort()
  else
    @volunteers = Volunteer.all
  end
  erb(:volunteers)
end

get('/volunteers/:id') do
  @volunteer = Volunteer.find(params[:id].to_i())
  erb(:volunteer)
end

get('/volunteers/:id/edit') do
@volunteer = Volunteer.find(params[:id].to_i())
erb(:edit_volunteer)
end

post('/volunteers') do
  name = params[:name]
  volunteer = Volunteer.new(:name => name, :id => nil)
  volunteer.save()
  @volunteers = Volunteer.all()
  erb(:volunteers)
end

patch('/volunteers/:id') do
  @volunteer  = Volunteer.find(params[:id].to_i())
  @volunteer.update(params[:name])
  @volunteers = Volunteer.all
  erb(:volunteers)
end

delete('/volunteers/:id') do
  @volunteer = Volunteer.find(params[:id].to_i())
  @volunteer.delete()
  @volunteers = Volunteer.all
  erb(:volunteers)
end

post ('/volunteers/:id/projects') do
  @volunteer = Volunteer.find(params[:id].to_i())
  project_name = params[:project_name]
  # project = Project.new({:name => project_name, :id => nil})
  # project.save()
  @volunteer.update({:project_name => project_name})
  erb(:edit_volunteer)
end
