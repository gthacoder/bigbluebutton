package org.bigbluebutton.conference.service.chat;

public class ChatPrivateMessage {
	private Header header;
	private Payload payload;
	public static class Header{
		public String getName() {
			return name;
		}
		public void setName(String name) {
			this.name = name;
		}
		public String getTimestamp() {
			return timestamp;
		}
		public void setTimestamp(String timestamp) {
			this.timestamp = timestamp;
		}
		public String getSource() {
			return source;
		}
		public void setSource(String source) {
			this.source = source;
		}
		public Destination getDestination() {
			return destination;
		}
		public void setDestination(Destination destination) {
			this.destination = destination;
		}
		private String name;
		private String timestamp;
		private String source;
		private Destination destination;
		public static class Destination{
			public String getTo() {
				return to;
			}

			public void setTo(String to) {
				this.to = to;
			}

			private String to;
		}
	}//end of class Header
	public Header getHeader() {
		return header;
	}
	public void setHeader(Header header) {
		this.header = header;
	}

	public static class Payload{
		public Chat_message getChat_message() {
			return chat_message;
		}
		public void setChat_message(Chat_message chat_message) {
			this.chat_message = chat_message;
		}
		private Chat_message chat_message;
		public static class Chat_message{
			public String getSession() {
				return session;
			}
			public void setSession(String session) {
				this.session = session;
			}
			public String getTimestamp() {
				return timestamp;
			}
			public void setTimestamp(String timestamp) {
				this.timestamp = timestamp;
			}
			public String getCorrelation_id() {
				return correlation_id;
			}
			public void setCorrelation_id(String correlation_id) {
				this.correlation_id = correlation_id;
			}
			public To getTo() {
				return to;
			}
			public void setTo(To to) {
				this.to = to;
			}
			public From getFrom() {
				return from;
			}
			public void setFrom(From from) {
				this.from = from;
			}
			public Message getMessage() {
				return message;
			}
			public void setMessage(Message message) {
				this.message = message;
			}
			public Meeting getMeeting() {
				return meeting;
			}
			public void setMeeting(Meeting meeting) {
				this.meeting = meeting;
			}
			private String session;
			private String timestamp;
			private String correlation_id;
			private To to;
			private From from;
			private Message message;
			private Meeting meeting;
			public static class To{
				private String id;
				private String name;
				
				public String getId() {
					return id;
				}
				public void setId(String id) {
					this.id = id;
				}
				public String getName() {
					return name;
				}
				public void setName(String name) {
					this.name = name;
				}

			}
			public static class From{
				private String id;
				private String name;
				
				public String getId() {
					return id;
				}
				public void setId(String id) {
					this.id = id;
				}
				public String getName() {
					return name;
				}
				public void setName(String name) {
					this.name = name;
				}

			}
			public static class Message{
				private String text;
				private String lang;
				
				public String getText() {
					return text;
				}
				public void setText(String text) {
					this.text = text;
				}
				public String getLang() {
					return lang;
				}
				public void setLang(String lang) {
					this.lang = lang;
				}

			}
			public  static class Meeting{
				
				private String id; 
				public String getId() {
					return id;
				}

				public void setId(String id) {
					this.id = id;
				}				
			}
		}
	}//end of class Payload
	public Payload getPayload() {
		return payload;
	}
	public void setPayload(Payload payload) {
		this.payload = payload;
	}
}
