/**
* BigBlueButton open source conferencing system - http://www.bigbluebutton.org/
* 
* Copyright (c) 2012 BigBlueButton Inc. and by respective authors (see below).
*
* This program is free software; you can redistribute it and/or modify it under the
* terms of the GNU Lesser General Public License as published by the Free Software
* Foundation; either version 3.0 of the License, or (at your option) any later
* version.
* 
* BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY
* WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
* PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License along
* with BigBlueButton; if not, see <http://www.gnu.org/licenses/>.
*
*/
package org.bigbluebutton.conference.service.chat;

import java.util.HashMap;
import java.util.Map;
import com.google.gson.JsonObject;

public class ChatMessageVO {
    // The type of chat (PUBLIC or PRIVATE)
    public String chatType;
    
    // The sender
    public String fromUserID;    
    public String fromUsername;
    public String fromColor;
    
    // Stores the UTC time (milliseconds) when the message was sent.
    public Double fromTime;   
    // Stores the timezone offset (minutes) when the message was sent.
    // This will be used by receiver to convert to locale time.
    public Long fromTimezoneOffset;
    
    public String fromLang; 
    
    // The receiver. For PUBLIC chat this is empty
    public String toUserID = "";
    public String toUsername = "";
    
	public String message;
	public String meetingID;

			
	public Map<String, Object> toMap() {
		Map<String, Object> msg = new HashMap<String, Object>();
		msg.put("fromUserID", fromUserID);
		msg.put("fromUsername", fromUsername);
		msg.put("fromColor", fromColor);
		msg.put("fromTime", fromTime);
		msg.put("fromLang", fromLang);
		msg.put("fromTime", fromTime);
		msg.put("fromTimezoneOffset", fromTimezoneOffset);
		msg.put("chatType", chatType);
		msg.put("message", message);
		msg.put("toUserID", toUserID);
		msg.put("toUsername", toUsername);
		
		return msg;
	}
	
	public JsonObject toJsonObj(){
		JsonObject meeting = new JsonObject();
		meeting.addProperty("id", meetingID);
		JsonObject from = new JsonObject();
		from.addProperty("id", fromUserID);
		from.addProperty("name", fromUsername);
		JsonObject to = new JsonObject();
		to.addProperty("id", toUserID);
		to.addProperty("name", toUsername);
		JsonObject messageDetail = new JsonObject();
		messageDetail.addProperty("text", message);
		messageDetail.addProperty("lang", fromLang);
		JsonObject font = new JsonObject();
		font.addProperty("color", fromColor);
		font.addProperty("size", 14);
		font.addProperty("font_type", "Arial");
		JsonObject chatMessage = new JsonObject();
		chatMessage.add("to", to);
		chatMessage.add("from", from);
		chatMessage.add("meeting", meeting);
		chatMessage.add("font", font);
		chatMessage.add("message", messageDetail);
		chatMessage.addProperty("correlation_id", "user1-msg1");
		chatMessage.addProperty("timestamp", fromTime);
		JsonObject payload = new JsonObject();
		payload.add("chat_message", chatMessage);
		JsonObject destination = new JsonObject();
		destination.addProperty( "to", "apps_channel");
		JsonObject header = new JsonObject();
		header.add( "destination", destination);
		header.addProperty("name", chatType);
		header.addProperty("source", "bbb-apps");
		header.addProperty("timestamp", fromTime);
		JsonObject PrivateChatMessageEventJson   = new JsonObject();
		PrivateChatMessageEventJson.add("header", header);
		PrivateChatMessageEventJson.add("payload", payload);
		return PrivateChatMessageEventJson;
	}
}
