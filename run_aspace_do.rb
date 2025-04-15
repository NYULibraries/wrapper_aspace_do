require 'open3'

EXPECTED_ARG_COUNT = 3

#------------------------------------------------------------------------------
# constants
#------------------------------------------------------------------------------
ALLOWED_USAGES = %w(audio-service video-service image-service image-thumbnail)
DO_URI_FNAME   = 'archival_object_uri'
HANDLE_FNAME   = 'handle'
HANDLE_PREFIX  = 'https://hdl.handle.net/'
THUMBNAIL_URL_APPEND = '?urlappend=/mode/thumb'

PAUSE_DURATION_SECONDS = 2
PAUSE_EVERY_N_OBJECTS = 3

#------------------------------------------------------------------------------
# helper methods
#------------------------------------------------------------------------------
def print_err(str)
  $stderr.puts(str)
end

def script_usage
<<END_OF_USAGE
Usage: $ ruby #{__FILE__} <file with directory list> <usage statement> <path-to-dir-root>
  e.g., $ ruby #{__FILE__} nitrates.txt 'image-service' /path/to/wips/

  Valid usage statements:
  #{ALLOWED_USAGES.inject('') {|str, u| str << "#{u} "}}

  Please note:
  if the usage statement == 'image-thumbnail', the string '#{THUMBNAIL_URL_APPEND}' will
  automatically be appended to the handle url.

  Please note:
  you must specify the path the the aspace-do-update executable using
  the environment variable 'RUN_ASPACE_DO_UPDATER_PATH'
  e.g.,
  $ export RUN_ASPACE_DO_UPDATER_PATH=/path/to/aspace-do-update/bin/aspace-do-update

  NOTE:
  the script will pause for #{PAUSE_DURATION_SECONDS} seconds every #{PAUSE_EVERY_N_OBJECTS} objects
  to avoid overwhelming the server.
END_OF_USAGE
end

def assert_arg_count
  if ARGV.length != EXPECTED_ARG_COUNT
    print_err 'ERROR: incorrect number of arguments'
    print_err script_usage
    exit 1
  end
end

def assert_usage(usage)
  unless ALLOWED_USAGES.include?(usage)
    raise "Illegal argument. Allowed values are: \n" + ALLOWED_USAGES.join("\n")
  end
end

def assert_file(f)
  unless File.readable?(f)
    raise "File '#{f}' is not readable or does not exist"
  end
end

def assert_path(p)
  unless File.directory?(p)
    raise "Path '#{p}' is not a directory or does not exist"
  end
end

def get_updater_script!
  updater_script = ENV['RUN_ASPACE_DO_UPDATER_PATH']
  if updater_script.nil?
    raise "ERROR! unable to determine aspace updater script path.\n" +
      "Environment variable RUN_ASPACE_DO_UPDATER_PATH must be specified"
  end

  unless File.executable?(updater_script)
    raise "ERROR! #{updater_script} in not executable or does not exist"
  end

  updater_script
end

#------------------------------------------------------------------------------
# MAIN
#------------------------------------------------------------------------------
assert_arg_count

# extract args
file  = ARGV[0]
usage = ARGV[1]
path  = ARGV[2]
updater_script = get_updater_script!

assert_file(file)
assert_usage(usage)
assert_path(path)

entries = []
File.open(file, 'r').each_line do |line|
  dir = line.chomp
  next if dir.empty?
  entries.push("#{path}/#{dir}")
end

# load up the DO info hash
do_info = {}
entries.each { |e|
  do_uri = File.open("#{e}/#{DO_URI_FNAME}").first
  do_uri = do_uri.chomp
  handle = File.open("#{e}/#{HANDLE_FNAME}").first
  handle = handle.chomp
  handle_url = HANDLE_PREFIX + handle + (usage == 'image-thumbnail' ? THUMBNAIL_URL_APPEND : '')
  key = File.basename(e)
  do_info[key] = [do_uri, handle_url]
}

# create DOs, pausing every PAUSE_EVERY_N_OBJECTS
pause_count = 0
do_info.each_pair { |k,v|
  puts "#{k}: #{v}"
  do_uri = v[0]
  handle_url = v[1]
  cmd = "#{updater_script} -a #{do_uri} -f #{handle_url} -u #{usage}"
  puts cmd
  o, e, s = Open3.capture3(cmd)
  unless s.exitstatus == 0
    raise "ERROR! Encountered problem processing #{k} #{v}\noutput: #{o}\nerror: #{e}\nstatus: #{s}"
  end
  puts "aspace-do-uri: #{o}"

  pause_count += 1
  if (pause_count % PAUSE_EVERY_N_OBJECTS) == 0
    puts "#{pause_count}: pausing for #{PAUSE_DURATION_SECONDS} seconds..."
    sleep PAUSE_DURATION_SECONDS
  end
}
