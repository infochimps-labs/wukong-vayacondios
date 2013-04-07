# -*- encoding: utf-8 -*-
require File.expand_path('../lib/wukong-vayacondios/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'wukong-vayacondios'
  gem.homepage    = 'https://github.com/infochimps-labs/wukong-vayacondios'
  gem.licenses    = ["Apache 2.0"]
  gem.email       = 'coders@infochimps.com'
  gem.authors     = ['Infochimps', 'Philip (flip) Kromer', 'Travis Dempsey', 'Dhruv Bansal']
  gem.version     = Wukong::Vayacondios::VERSION

  gem.summary     = ''
  gem.description = <<-EOF
  Lets you load data from the command-line into data stores like

  * Elasticsearch
  * MongoDB
  * HBase
  * MySQL
  * Kafka

and others.
EOF

  gem.files         = `git ls-files`.split("\n")
  gem.executables   = ['wu-load', 'wu-source']
  gem.test_files    = gem.files.grep(/^spec/)
  gem.require_paths = ['lib']

  gem.add_dependency('wukong', '3.0.1')
end
