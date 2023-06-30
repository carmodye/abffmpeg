const fs = require('fs');

function getDirectories(path) {
  return fs.readdirSync(path, { withFileTypes: true })
    .filter(dirent => dirent.isDirectory())
    .map(dirent => dirent.name);
}

exports.handler = async event => {
  // Log the event argument for debugging and for use in local development.
  console.log(JSON.stringify(event, undefined, 2));
// Usage Example:
const directoryPath = '/opt';
const directories = getDirectories(directoryPath);
console.log(directories);

    const response = {
      statusCode: 200,
      body: directories,
    };
    return response;
  };
