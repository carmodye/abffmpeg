Used this to create ffmpeg.zip layer

How to use FFmpeg within lambda function via layers
https://www.youtube.com/watch?v=rN_uyF_CgdQ
www.youtube.com


example python one I can follow
https://aws.amazon.com/blogs/media/processing-user-generated-content-using-aws-lambda-and-ffmpeg/


This is javascript one that does process from sam applications does not deploy because of layer issues
https://github.com/simalexan/s3-lambda-ffmpeg-mov-to-mp4-s3/blob/master/src/index.js

The example.js shows how to read a file into /tmp and run ffmpeg etc.


call the service with json file name and commands to run example
{
  "cmd": "some commands???",
  "filename": "sample-mp4-file1.mp4"
}