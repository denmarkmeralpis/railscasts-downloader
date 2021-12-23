#!/usr/bin/ruby

#######################################################
#
# NOTE:
#   Make sure you've installed `wget`. Tested on MacOS
#
#######################################################

require 'fileutils'
require 'json'

BASE_DIR = './episodes'

def setup
  download_dirs.each do |dir|
    FileUtils.mkdir_p(dir) unless Dir.exists?(dir)
  end
end

def episodes
  JSON.parse File.read('episodes.json')
end

def download_dirs
  episodes.keys.map { |dir| "#{BASE_DIR}/#{dir}/" }
end

def download_video(url, path)
  temp_path = "#{path}.tmp"

  %x(wget #{url} -O #{temp_path} -q)
  %x(mv #{temp_path} #{path})
end

def perform_download
  episodes.each do |episode, videos|
    count = videos.count

    videos.each_with_index do |url, i|
      filename = url.split('/').last
      path = "#{BASE_DIR}/#{episode}/#{filename}"

      next if File.exists?(path)

      print "Downloading RailsCasts #{episode.capitalize} ( #{i + 1}/#{count} )\r"
      download_video(url, path)
    end
  end

  puts "Done. Enjoy!"
end

def download
  setup
  perform_download
end

download