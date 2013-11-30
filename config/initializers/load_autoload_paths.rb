# Copyright 2013 Square Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

# Not sure why this isn't done automatically by Jetty/Jetpack, but oh well.

if Rails.application.config.cache_classes
  Rails.application.config.autoload_paths.each do |path|
    Dir.glob(path.join('**', '*.rb')).each { |file| require file }
  end
end