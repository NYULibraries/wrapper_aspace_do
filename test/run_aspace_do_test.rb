require 'test_helper'
require 'open3'

class RunAspaceDo < MiniTest::Test

  COMMAND = 'ruby run_aspace_do.rb'

  OK_WIP_LIST_FILE            = 'test/fixtures/wip-list-files/ok-wip-list.txt'
  OK_WIP_PATH                 = 'test/fixtures/ok-wips'

  def test_with_incorrect_argument_count
    o, e, s = Open3.capture3("#{COMMAND}")
    assert(s.exitstatus != 0)
    assert(o == '')
    assert_match(/usage/, e)
    assert_match(/incorrect number of arguments/, e)
  end

  def test_valid_invocation
    env = {'RUN_ASPACE_DO_UPDATER_PATH' => 'test/mock_scripts/good-aspace-do-update'}
    o, e, s = Open3.capture3(env, "#{COMMAND} #{OK_WIP_LIST_FILE} 'audio-service' #{OK_WIP_PATH}")
    assert(s.exitstatus == 0, "exit status: #{s.exitstatus}")
    o_array = o.split("\n")
    assert('bar: ["bar-uri", "http://hdl.handle.net/bar-handle"]' == o_array[0]) 
    assert("#{env['RUN_ASPACE_DO_UPDATER_PATH']} -a bar-uri -f http://hdl.handle.net/bar-handle -u audio-service" == o_array[1])
    assert('success!' == o_array[2]) 
    assert('foo: ["foo-uri", "http://hdl.handle.net/foo-handle"]' == o_array[3]) 
    assert("#{env['RUN_ASPACE_DO_UPDATER_PATH']} -a foo-uri -f http://hdl.handle.net/foo-handle -u audio-service" == o_array[4])
    assert('success!' == o_array[5]) 
    assert(e == '')
  end
end
