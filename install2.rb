#!/usr/bin/env ruby

require 'mkmf'
require 'byebug' if RUBY_PLATFORM.include?("darwin")

class StartupInstaller
  attr_reader :pattern, :script

  def initialize(pattern:, script:)
    @pattern = pattern
    @script = script
  end

  def bashrc_filename
    if RUBY_PLATFORM.include?("darwin")
      # testing on a dummy file in Mac
      File.expand_path(".bashrc.sample", __dir__)
    else
      File.expand_path("~/.bashrc")
    end
  end

  def perform
    if File.exists?(bashrc_filename)
      lines = File.open(bashrc_filename).each_line.to_a
      found = false
      lines.each_with_index do |line, index|
        if line.include?(pattern)
          lines[index] = script
          found = true
          break
        end
      end

      unless found
        lines << script << "\n"
      end

      File.write(bashrc_filename, lines.join(""))
    else
      File.write(bashrc_filename, script)
    end
  end
end

class Installer
  def perform
    puts "Installing"
    install_sox
    download_loop_script
    run_loop_script_on_startup
    test_broadcast
    reload_broadcast
  end

  def install_sox
    unless find_executable("play")
      system "pkg update"
      system "pkg install -y sox"
    end
  end

  def download_loop_script
    url = "https://raw.githubusercontent.com/passivon/passivon/main/broadcast-daily"
    system "wget -O bin-broadcast-daily #{url}"
    system "chmod u+x bin-broadcast-daily"
  end

  def run_loop_script_on_startup
    StartupInstaller.new(
      pattern: "broadcast-daily",
      script: %(#{File.expand_path("bin-broadcast-daily", __dir__)} -m &)
    ).perform
  end

  def test_broadcast
    cmd = %(#{File.expand_path("bin-broadcast-daily", __dir__)} -t)
    system cmd
  end

  def reload_broadcast
    system %(#{File.expand_path("bin-broadcast-daily", __dir__)} -k)
    system %(#{File.expand_path("bin-broadcast-daily", __dir__)} -m &)
  end
end

Installer.new.perform
