exports.handler = async (event) => {
  const AWS = require('aws-sdk');

  const s3IN = new AWS.S3();
  const s3OUT = new AWS.S3();
  // get env variables
  const inBucket = process.env.VIDINBUCKET_BUCKET_NAME;
  const outBucket = process.env.VIDOUTBUCKET_BUCKET_NAME;
  
  var params = {Bucket: inBucket, Key: JSON.parse(event.body).filename}
  var s3file = s3IN.getObject(params)
  
    
  // call linux cmds
  const execSync = require('child_process').execSync;
  const output1 = execSync('/opt/ffmpeglib/ffprobe -h', { encoding: 'utf-8' });  
  const output = execSync('/opt/ffmpeglib/ffmpeg -h', { encoding: 'utf-8' });  



  // Parse the JSON data
  const cmd = JSON.parse(event.body).cmd;
  const filename = JSON.parse(event.body).filename;
  //let concatenatedString = cmd + " " + filename + " " + output;
  let concatenatedString = cmd + " " + filename ;
  
  const response = {
      statusCode: 200,
      body: JSON.stringify(concatenatedString),
  };
  return response;
};