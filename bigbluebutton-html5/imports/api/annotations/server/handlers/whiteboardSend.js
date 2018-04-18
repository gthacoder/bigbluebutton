import { check } from 'meteor/check';

import addAnnotation from '../modifiers/addAnnotation';
import RedisPubSub from '/imports/startup/server/redis';

export default function handleWhiteboardSend({ header, body }, meetingId) {
  console.log('HANDLE_WHITEBOARD_SEND');
  const userId = header.userId;
  const annotation = body.annotation;

  check(userId, String);
  check(annotation, Object);

  const whiteboardId = annotation.wbId;

  check(whiteboardId, String);

  /*console.log('---meetingId:---');
  console.log(meetingId);
  console.log('---whiteboardId:---');
  console.log(whiteboardId);
  console.log('---userId:---');
  console.log(userId);
  console.log('---annotation:---');
  console.log(annotation);*/
  /*console.log('---final object:---');
  console.log(JSON.stringify({
    meetingId: meetingId,
    whiteboardId: whiteboardId,
    userId: userId,
    annotation: annotation
  }));*/

  console.log('**********Pushing to bulk**********');
  console.log('Annotation being pushed:');
  console.log(JSON.stringify({
    meetingId: meetingId,
    whiteboardId: whiteboardId,
    userId: userId,
    annotation: annotation
  }));
  RedisPubSub.addToAnnotationsBulk({
    meetingId: meetingId,
    whiteboardId: whiteboardId,
    userId: userId,
    annotation: annotation
  });
  //return addAnnotation(meetingId, whiteboardId, userId, annotation);
}
