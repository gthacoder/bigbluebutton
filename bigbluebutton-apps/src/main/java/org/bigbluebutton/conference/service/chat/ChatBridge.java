package org.bigbluebutton.conference.service.chat;

import java.util.ArrayList;
import java.util.HashMap;

import org.bigbluebutton.conference.service.messaging.MessagingConstants;
import org.bigbluebutton.conference.service.messaging.MessagingService;

import redis.clients.jedis.Jedis;

import com.google.gson.Gson;
import com.google.gson.JsonObject;


public class ChatBridge {
	
	private MessagingService messagingService;
	
	public void sendMsg(String meetingID, ChatMessageVO chat){
		ArrayList<Object> updates = new ArrayList<Object>();
		updates.add(meetingID);
		updates.add("msg");
		updates.add(chat.fromUsername);
		updates.add(chat.message);
		updates.add(chat.fromUserID);
		updates.add(chat.chatType);
		updates.add(chat.toUsername);
		updates.add(chat.toUserID);
		Gson gson = new Gson();

		messagingService.send(MessagingConstants.BIGBLUEBUTTON_BRIDGE, gson.toJson(updates));
	}
	
	public void sendPrivateMsg(String meetingID, ChatMessageVO chat){
		/*
		ArrayList<Object> updates = new ArrayList<Object>();
		updates.add(meetingID);
		updates.add("privateMsg");
		updates.add(chat.fromUsername);
		updates.add(chat.message);
		updates.add(chat.fromUserID);
		updates.add(chat.chatType);
		updates.add(chat.toUsername);
		updates.add(chat.toUserID);
		 */
		//Gson gson = new Gson();		
	//	messagingService.send(MessagingConstants.BIGBLUEBUTTON_BRIDGE,PrivateChatMessageEventJson.toString());
		messagingService.send("bigbluebutton_bridge:privateMsg",chat.toJsonObj().toString());

	}
	
	public MessagingService getMessagingService() {
		return messagingService;
	}

	public void setMessagingService(MessagingService messagingService) {
		this.messagingService = messagingService;
	}

	public void storeMsg(String meetingID, ChatMessageVO chatobj) {
		Jedis jedis = messagingService.createRedisClient();
		
		HashMap<String,String> map = new HashMap<String, String>();
		long messageid = System.currentTimeMillis();
		
		map.put("message", chatobj.message);
		map.put("fromUsername", chatobj.fromUsername);
		map.put("fromUserID", chatobj.fromUserID);
		map.put("toUsername",chatobj.toUsername);
		map.put("toUserID",chatobj.toUserID);
		map.put("chatType",chatobj.chatType);
		jedis.hmset("meeting-"+meetingID+"-message-"+messageid, map);
		jedis.rpush("meeting-"+meetingID+"-messages", Long.toString(messageid));
		
		messagingService.dropRedisClient(jedis);
	}

}
