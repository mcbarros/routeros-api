# RouterOS::API

Simple Ruby implementation of the [RouterOS API protocol](https://help.mikrotik.com/docs/display/ROS/API).

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add routeros-api

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install routeros-api

## Usage

```ruby
api = RouterOS::API.new('192.168.1.1', 8728)
response = api.login('admin', 'my_password')

if response.ok?
  response = api.command('ip/route/getall')
  puts(response.data)
end
```

### Async

Async gem is supported but not required, if the gem can be loaded a method `async_command` will be available. Look at the examples folder for a full example.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mcbarros/routeros-api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/mcbarros/routeros-api/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RouterOS::API project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mcbarros/routeros-api/blob/main/CODE_OF_CONDUCT.md).
