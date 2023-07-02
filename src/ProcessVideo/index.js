exports.handler = async (event) => {
  const AWS = require('aws-sdk');
  const s3 = new AWS.S3();
  // TODO implement
  const execSync = require('child_process').execSync;
  const output = execSync('/opt/ffmpeglib/ffmpeg -h', { encoding: 'utf-8' });  
  // the default is 'buffer'
  //console.log('Output was:\n', output);
  const requestBody = JSON.parse(event.body);

  // Parse the JSON data
  //const jsonData = JSON.parse(requestBody);
  //const name = jsonData.cmd;
  //const filename = jsonData.filename;
  //let concatenatedString = name + " " + filename;
  
  const response = {
      statusCode: 200,
      body: JSON.stringify(event.body),
  };
  return response;
};