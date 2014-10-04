
package org.bigbluebutton.conference.service.participants;


import org.bigbluebutton.conference.service.messaging.MessagingConstants;
import org.bigbluebutton.conference.service.messaging.redis.MessageHandler;
//import org.bigbluebutton.core.api.*;

import org.bigbluebutton.core.api.IBigBlueButtonInGW;
import com.google.gson.JsonParser;
import com.google.gson.JsonObject;

public class ParticipantsListener implements MessageHandler{

        private IBigBlueButtonInGW bbbInGW;

        public void setBigBlueButtonInGW(IBigBlueButtonInGW bbbInGW) {
                this.bbbInGW = bbbInGW;
        }

        @Override
        public void handleMessage(String pattern, String channel, String message) {
                if (channel.equalsIgnoreCase(MessagingConstants.TO_USERS_CHANNEL)) {

                        JsonParser parser = new JsonParser();
                        JsonObject obj = (JsonObject) parser.parse(message);
                        JsonObject headerObject = (JsonObject) obj.get("header");
                        JsonObject payloadObject = (JsonObject) obj.get("payload");

                        String eventName =  headerObject.get("name").toString().replace("\"", "");

                        if(eventName.equalsIgnoreCase("user_leaving_request") ||
                                eventName.equalsIgnoreCase("user_raised_hand_message") ||
                                eventName.equalsIgnoreCase("user_lowered_hand_message") ||
                                eventName.equalsIgnoreCase("user_status_changed_message") ||
                                eventName.equalsIgnoreCase("presenter_assigned_message") ||
                                eventName.equalsIgnoreCase("kick_user_from_meeting_message")){

                                String roomName = payloadObject.get("meeting_id").toString().replace("\"", "");

                                if(eventName.equalsIgnoreCase("presenter_assigned_message")){
                                        String newPresenterID = payloadObject.get("new_presenter_id").toString().replace("\"", "");
                                        String newPresenterName = payloadObject.get("new_presenter_name").toString().replace("\"", "");
                                        String assignedBy = payloadObject.get("assigned_by").toString().replace("\"", "");
                                        bbbInGW.assignPresenter(roomName, newPresenterID, newPresenterName, assignedBy);
                                }
                                else {
                                        String userID = payloadObject.get("userid").toString().replace("\"", "");

                                        if(eventName.equalsIgnoreCase("user_leaving_request")){
                                                bbbInGW.userLeft(roomName, userID);
                                        }
                                        else if(eventName.equalsIgnoreCase("user_raised_hand_message")){
                                                bbbInGW.userRaiseHand(roomName, userID);
                                        }
                                        else if(eventName.equalsIgnoreCase("user_lowered_hand_message")){
                                                String requesterID = payloadObject.get("lowered_by").toString().replace("\"", "");
                                                bbbInGW.lowerHand(roomName, userID, requesterID);
                                        }
                                        else if(eventName.equalsIgnoreCase("user_status_changed_message")){
                                                String status = payloadObject.get("status").toString().replace("\"", "");
                                                String value = payloadObject.get("value").toString().replace("\"", "");
                                                bbbInGW.setUserStatus(roomName, userID, status, value);
                                        }
                                        else if(eventName.equalsIgnoreCase("kick_user_from_meeting_message")) {
                                                String ejectedBy = payloadObject.get("ejected_by").toString().replace("\"", "");
                                                System.out.println("kick_user_from_meeting_message");
                                                bbbInGW.ejectUserFromMeeting(roomName, userID, ejectedBy);
                                        }
                                }
                        }
                }
        }
}
