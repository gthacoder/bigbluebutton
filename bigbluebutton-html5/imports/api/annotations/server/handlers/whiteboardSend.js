import { check } from 'meteor/check';

import addAnnotation from '../modifiers/addAnnotation';
import RedisPubSub from '/imports/startup/server/redis';

export default function handleWhiteboardSend({ header, body }, meetingId) {
  const userId = header.userId;
  const annotation = body.annotation;

  check(userId, String);
  check(annotation, Object);

  const whiteboardId = annotation.wbId;

  check(whiteboardId, String);

  RedisPubSub.addToAnnotationsBulk({
    meetingId: meetingId,
    whiteboardId: whiteboardId,
    userId: userId,
    annotation: annotation
  });
  //return addAnnotation(meetingId, whiteboardId, userId, annotation);
}
