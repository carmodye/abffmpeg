exports.handler = async (event) => {
  // TODO implement
  const execSync = require('child_process').execSync;
  const output = execSync('/opt/ffmpeglib/ffmpeg -h', { encoding: 'utf-8' });  // the default is 'buffer'
  console.log('Output was:\n', output);
  
  const response = {
      statusCode: 200,
      body: JSON.stringify(output),
  };
  return response;
};