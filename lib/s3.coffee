Upload = require('s3-uploader')

module.exports = new Upload 'factory-vote',
  awsBucketUrl: 'https://s3-us-east-1.amazonaws.com/factory-vote/',
  awsBucketPath: 'entries/',
  awsBucketAcl: 'public',

  versions: [{
    original: true
  },{
    suffix: '-large',
    quality: 80
    maxHeight: 1040,
    maxWidth: 1040,
  },{
    suffix: '-small',
    maxHeight: 320,
    maxWidth: 320
  }]
