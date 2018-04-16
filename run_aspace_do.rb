require 'open3'

def chk_usage(usage)
  usage = allowed.include?(usage)? usage : nil
end

def allowed
  %w(audio-service video-service image-service image-thumbnail)
end
file = ARGV[0]
usage = ARGV[1]
path = ARGV[2] 
if usage.nil?
 raise "Illegal argument. Allowed values are allowed.join(" ")"
end 
do_uri_fname = "archival_object_uri"
handle_fname = "handle" 
# Add path to aspace-do-update/bin script
APP_LOCATION=""
updater_script = "aspace-do-update"
usage = chk_usage(usage)
handle_prefix = "http://hdl.handle.net/"
entries = []
if File.exist?(file)
   File.open(file,"r").each_line do |line|
     dir = line.chomp
     entries.push("#{path}/#{dir}")
   end
end

do_info = {}
entries.each { |e|
  do_uri = File.open("#{e}/#{do_uri_fname}").first
  do_uri = do_uri.chomp
  handle = File.open("#{e}/#{handle_fname}").first
  handle = handle.chomp
  key = File.basename(e)
  do_info[key] = [do_uri,handle_prefix+handle]
}
do_info.each_pair { |k,v|
  puts "#{k}: #{v}"
  do_uri = v[0]
  handle = v[1]
  cmd = "#{APP_LOCATION}/#{updater_script} -a #{do_uri} -f #{handle} -u #{usage}"
  puts cmd
  status = system(cmd)
  puts status 
}


