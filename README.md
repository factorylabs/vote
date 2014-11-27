# FDL Employees Vote!

## Tech

Postgres

Node.js

* `coffeescript`
* `express`
* `bookshelf` + `knex`
* `jade` + `stylus`
* `knox` for S3 storage

## Notes

Admins are set in the `config.coffee` file.

Vote doesn't clean up after itself in its S3 bucket.

### Sample `env.coffee`

```coffeescript
module.exports = (config) ->
  if config.env is 'development'
    # s3 uploader expects these to be set
    config.aws_key_id = 'foobar'
    config.aws_secret_key = 'baz'

    return config
```
