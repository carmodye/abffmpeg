exports.handler = async (event , context) => {
  const AWS = require('aws-sdk');
  
  // get env variables
  
  const s3Util = require('./s3-util'),
	childProcessPromise = require('./child-process-promise'),
	path = require('path'),
	os = require('os'),
  OUTPUT_BUCKET = process.env.VIDOUTBUCKET_BUCKET_NAME,
  INPUT_BUCKET = process.env.VIDINBUCKET_BUCKET_NAME;

  const s3IN = new AWS.S3();
  const s3OUT = new AWS.S3();
  
  var params = {Bucket: INPUT_BUCKET, Key: JSON.parse(event.body).filename}
  
  var s3file = s3IN.getObject(params)
 
  const 	workdir = os.tmpdir(),
  id = context.awsRequestId,
  inputFile = path.join(workdir,  id + JSON.parse(event.body).filename),
  outputFile = path.join(workdir, 'converted-' + id);
      
  
  // call linux cmds
//  const execSync = require('child_process').execSync;
//  const output1 = execSync('/opt/ffmpeglib/ffprobe -h', { encoding: 'utf-8' });  
//  const output = execSync('/opt/ffmpeglib/ffmpeg -h', { encoding: 'utf-8' });  

// pull file
s3Util.downloadFileFromS3(  process.env.VIDINBUCKET_BUCKET_NAME
  , JSON.parse(event.body).filename, inputFile);

//  const execSync = require('child_process').execSync;
//  const output = execSync('ls -l inputFile', { encoding: 'utf-8' });


//return s3Util.downloadFileFromS3(inputBucket, key, inputFile)
//.then(() => childProcessPromise.spawn(
//  '/opt/bin/ffmpeg',
//  ['-loglevel', 'error', '-y', '-i', inputFile, '-f', 'mp4',  outputFile],
//  {env: process.env, cwd: workdir}
//))
//.then(() => s3Util.uploadFileToS3(OUTPUT_BUCKET, resultKey, outputFile, MIME_TYPE));



  // Parse the JSON data
  const cmd = JSON.parse(event.body).cmd;
  const filename = JSON.parse(event.body).filename;
  //let concatenatedString = cmd + " " + filename + " " + output;
  let concatenatedString = cmd + " " + filename + inputFile + " " + outputFile;
  
  const response = {
      statusCode: 200,
      body: JSON.stringify(concatenatedString),
  };
  return response;
};