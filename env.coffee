module.exports = (config) ->
  if config.env is 'development'
    # s3 uploader expects these to be set
    console.log 'Setting AWS credentials.'
    process.env['AWS_ACCESS_KEY_ID'] = 'foo'
    process.env['AWS_SECRET_ACCESS_KEY'] = 'bar'

  return config
