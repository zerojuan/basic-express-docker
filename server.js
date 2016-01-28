'use strict';

const express = require( 'express' );
const aws = require( 'aws-sdk' );

// Constants
const PORT = 8080;

var s3 = new AWS.S3();

// App
const app = express();
app.get('/', function (req, res) {
  // query an S3 object
  s3.getListBuckets({}, function( err, data ) {
    if ( err) {
      return req.send( err );
    }

    return req.send( data.Buckets );
  });
});

app.listen(PORT);
console.log('Running on http://localhost:' + PORT);
