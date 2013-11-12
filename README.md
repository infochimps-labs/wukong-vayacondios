# Wukong-Vayacondios

This Wukong plugin integrates Wukong with
[Vayacondios](http://github.com/infochimps-labs/vayacondios/tree/leslie).

It provides

* a default Vayacondios client for the entire deploy pack with options that make it configurable by all wu-* tools
* methods for the [Processor](http://github.com/infochimps-labs/wukong/tree/leslie/lib/wukong/processor.rb) class to announce/search events and set/get/delete/search stashes.
* new processors which announce events and set stashes on each input record for use in flows

## Installation

To include the Wukong-Vayacondios plugin in your deploy pack, first
add it to your Gemfile:

```ruby
# in Gemfile.rb
gem 'wukong-vayacondios', git: 'https://github.com/infochimps-labs/wukong-vayacondios', branch: 'leslie'
```

You may also have to add the following line to
`config/initializers/plugins.rb` if you want to make
Wukong-Vayacondios globally accessible (depends on how you've
configured the environment of your deploy pack).

```ruby
# in config/initializers/plugins.rb
require 'wukong-vayacondios'
```

## Default Vayacondios Client

Wukong-Vayacondios provides a default
[Vayacondios::Client](https://github.com/infochimps-labs/vayacondios/blob/leslie/lib/vayacondios/client/client.rb)
at `Wukong::Deploy.vayacondios_client`.  This client object is
automatically initialized and configured during the startup of any
`wu-*`-tool.

### Configuration

The default Vayacondios client is configured by the following settings
which should appear on all `wu-*`-tools if Wukong-Vayacondios is
loaded in your deploy pack:

* vcd      -- turn on interaction with Vayacondios (dry_run mode otherwise)
* vcd_host -- host for Vayacondios server
* vcd_port -- port for Vayacondios server

If the `--vcd` option is not passed on the command-line:

```
$ wu-local my_flow --vcd
```

or set in a configuration file

```yaml
# in config/settings.yml
vcd: true
```

then all interactions with Vayacondios using the default client will
be in "dry run" mode -- logging but not performing any requests.

### Usage

Once the Wukong environment has booted and code in your processor or
model is running you can directly interact with the Vayacondios client
at any time:

```ruby
# in app/models/my_model.rb
def perform_some_risky_action!
  Wukong::Deploy.vayacondios_client.announce(:risky_actions, { id: self.id, ... })
  ...
end
```

It's more common to write to Vayacondios from processors or dataflows
which is why convenience methods and classes have already been created
for those contexts, as detailed in the next sections.

## New Processor Methods

The following methods are now added to the [Wukong::Processor](http://github.com/infochimps-labs/wukong/tree/leslie/lib/wukong/processor.rb) class

* announce -- for announcing an event
* events -- for searching events
* get -- for retrieving a stash
* stashes -- for searching stashes
* set -- for merging data into a stash
* set_many -- for merging data into many stashes via a query
* set! -- for replacing data in a stash
* set_many! -- for replacing data in many stashes via a query
* delete -- for deleting a stash
* delete_many -- for deleting many stashes via a query

Each method delegates to the corresponding method of [Vayacondios::Client](https://github.com/infochimps-labs/vayacondios/blob/leslie/lib/vayacondios/client/client.rb).

## New Processors

The following new processors are defined:

* lookup -- for using an input record to form a query whose response is yielded
* announce -- for using an input record to announce an event
* stash -- for using an input record to merge in a stash
* stash! -- for using an input record to replace in a stash

Vayacondios requires a `topic` for each of these operations to be
well-defined so each processor can be either instantiated with a topic
when used in a dataflow, as in the following example:
```ruby
# in messy_source.rb
Wukong.dataflow(:messy_source) do
  from_json | recordize(model: SourceModel) | 
    [
	  select(&:valid?) | do_more_stuff | ... | to_json,
	  select(&:invalid?) | announce(topic: 'malformed')
	]
end
```
or the input records themselves must have a topic property.

The `lookup`, `stash`, and `stash!` processors work similarly.
