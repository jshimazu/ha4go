def relative_path(path)
  "#{File.dirname(__FILE__)}/#{path}"
end

def read_relative(path)
  File.read relative_path path
end

def load_seed_from_yaml(file_name)
  file_path = relative_path(file_name)
  return warn "#{file_name} does not exist file." unless File.exist?(file_path)
  if block_given?
    yml = YAML.load(read_relative(file_name))
    yml.each { |y| yield y }
  end
end

load_seed_from_yaml('users.yml') do |user|
  auth = JSON.parse(user.to_json, object_class: OpenStruct)
  user = User.from_omniauth(auth)
  user.update(email: auth.email, description: "私の名前は #{user.name}")
end
load_seed_from_yaml('projects.yml')
