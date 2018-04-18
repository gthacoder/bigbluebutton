import _ from 'lodash';
import { check } from 'meteor/check';
import clearAnnotations from '../modifiers/clearAnnotations';
import addAnnotation from '../modifiers/addAnnotation';

export default function handleWhiteboardAnnotations({ body }, meetingId) {
  console.log('HANDLE_WHITEBOARD_ANNOTATIONS');
  check(meetingId, String);
  check(body, Object);

  const { annotations, whiteboardId } = body;

  check(whiteboardId, String);
  clearAnnotations(meetingId, whiteboardId);

  const annotationsAdded = [];
  _.each(annotations, (annotation) => {
    const { wbId, userId } = annotation;
    annotationsAdded.push(addAnnotation(meetingId, wbId, userId, annotation));
  });

  return annotationsAdded;
}
