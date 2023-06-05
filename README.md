# RedisJSON

A Ruby client for the [RedisJSON](https://redis.io/docs/stack/json/) module of the Redis Stack.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'redis-json', '~> 1.0'
```

And then execute:

```bash
$ bundle
```

Or you can install the gem on its own:

```bash
gem install redis-json
```

## Usage

This gem builds on the [redis-rb](https://github.com/redis/redis-rb) gem. It add a `Redis#json` method, through which you can call the JSON-specific Redis commands:

```ruby
redis = Redis.new

hash = {
  number: 1,
  string: 'example',
  empty_object: {}
}
redis.json.set 'key', hash # => OK
```

Input values will be converted to JSON strings using `JSON.generate`, and returned JSON strings will be parsed to Ruby objects using `JSON.parse`. You can use, respectively, `generate_options` and `parse_options` to specify options that will be passed on to the `JSON` methods:

```ruby
r.json.get 'key'
# => {'number' => 10}

r.json.get 'key', parse_options: {symbolize_names: true}
# => {:number => 10}
```

The methods are defined to be as similar as possible to the respective RedisJSON commands. `key` and `value` parameters become positional arguments, while more "option-like" parameters become keyword arguments (for example, the `NX` and `XX` parameters of the `JSON.SET` command become the `nx:` and `xx:` keyword arguments of the `set` method). The exception to this rule is `path`: to allow for the different combinations of default and variadic arguments, `path` is a keyword argument for all methods except `get` and `mset`.

## Version numbers

RedisJSON loosely follows [Semantic Versioning](https://semver.org/), with a hard guarantee that breaking changes to the public API will always coincide with an increase to the `MAJOR` number.

Version numbers are in three parts: `MAJOR.MINOR.PATCH`.

- Breaking changes to the public API increment the `MAJOR`. There may also be changes that would otherwise increase the `MINOR` or the `PATCH`.
- Additions, deprecations, and "big" non breaking changes to the public API increment the `MINOR`. There may also be changes that would otherwise increase the `PATCH`.
- Bug fixes and "small" non breaking changes to the public API increment the `PATCH`.

Notice that any feature deprecated by a minor release can be expected to be removed by the next major release.

## Changelog

Full list of changes in [CHANGELOG.md](CHANGELOG.md)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/moku-io/redis-json.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
