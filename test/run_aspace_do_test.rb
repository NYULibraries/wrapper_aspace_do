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
    expected = 'bar: ["bar-uri", "http://hdl.handle.net/bar-handle"]' 
    actual   = o_array[0]
    assert( expected == actual, "unexpected handle output: expected: '#{expected}', actual: '#{actual}'")

    expected = "#{env['RUN_ASPACE_DO_UPDATER_PATH']} -a bar-uri -f http://hdl.handle.net/bar-handle -u audio-service"
    actual   = o_array[1]
    assert( expected == actual, "unexpected command string: expected: '#{expected}', actual: '#{actual}'")

    expected = 'aspace-do-uri: success!'
    actual   = o_array[2]
    assert( expected == actual, "unexpected result: expected: '#{expected}', actual: '#{actual}'")

    expected = 'foo: ["foo-uri", "http://hdl.handle.net/foo-handle"]'
    actual   = o_array[3]
    assert(expected == actual, "unexpected handle output: expected: '#{expected}', actual: '#{actual}'")

    expected = "#{env['RUN_ASPACE_DO_UPDATER_PATH']} -a foo-uri -f http://hdl.handle.net/foo-handle -u audio-service"
    actual   = o_array[4]
    assert( expected == actual, "unexpected command string: expected: '#{expected}', actual: '#{actual}'")

    expected = 'aspace-do-uri: success!'
    actual   = o_array[5]
    assert( expected == actual, "unexpected result: expected: '#{expected}', actual: '#{actual}'")
    assert(e == '', "unexpected error output: expected '', actual: '#{e}'")
  end

  def test_valid_invocation_for_thumbnails
    env = {'RUN_ASPACE_DO_UPDATER_PATH' => 'test/mock_scripts/good-aspace-do-update'}
    o, e, s = Open3.capture3(env, "#{COMMAND} #{OK_WIP_LIST_FILE} 'image-thumbnail' #{OK_WIP_PATH}")
    assert(s.exitstatus == 0, "exit status: #{s.exitstatus}")
    o_array = o.split("\n")
    assert('bar: ["bar-uri", "http://hdl.handle.net/bar-handle?urlappend=/mode/thumb"]' == o_array[0])
    assert("#{env['RUN_ASPACE_DO_UPDATER_PATH']} -a bar-uri -f http://hdl.handle.net/bar-handle?urlappend=/mode/thumb -u image-thumbnail" == o_array[1])
    assert('aspace-do-uri: success!' == o_array[2])
    assert('foo: ["foo-uri", "http://hdl.handle.net/foo-handle?urlappend=/mode/thumb"]' == o_array[3])
    assert("#{env['RUN_ASPACE_DO_UPDATER_PATH']} -a foo-uri -f http://hdl.handle.net/foo-handle?urlappend=/mode/thumb -u image-thumbnail" == o_array[4])
    assert('aspace-do-uri: success!' == o_array[5])
    assert(e == '')
  end
end
