require 'open3'

def email_process
  subject = "ArchivesSpace Update of digital object uris"
  msg = %Q{Hello,
           This is an automated message notifying you that digital object uris for #{COLLECTION}
           will be updated in Archives Space.
           
           If you have any concerns, please do not reply to this message. Contact: #{RESPONSE}}
  cmd = "mail -v -s '#{subject}' #{EMAIL} <<< '#{msg}'"
  stdout,err,status = Open3.capture3(cmd)
  if err.empty?
    puts "emailed #{EMAIL}"
  else
   puts "ERROR: #{err}"
  end
end
file = ARGV[0]
EMAIL = ARGV[1]
COLLECTION = ARGV[2]
path = ARGV[3] || "/content/prod/rstar/content/fales/mss055/wip/se"
RESPONSE = "ed64@nyu.edu"
email_process
do_uri_fname = "archival_object_uri"
handle_fname = "handle" 
APP_LOCATION="aspace-do-update/bin"
updater_script = "aspace-do-update"
usage = "image-service"
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


