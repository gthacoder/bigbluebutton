var layout = $("#layout");
var chat = $("#chat-btn");
var users = $("#users-btn");
var logoutBtn = $("#logout-btn");
var userclick, chatclick;

var chatArea = $("#chat");
var usersArea = $("#users");

/* Ensure the status is set right at page load. */
chat.toggleClass("active", layout.hasClass("chat-enabled"));
chatArea.attr("aria-expanded", "false");
//chatArea.attr("aria-hidden", "true");
users.toggleClass("active", layout.hasClass("chat-enabled"));
usersArea.attr("aria-expanded", "false");
//usersArea.attr("aria-hidden", "true");

chat.click(function() {
  if(chatclick) clearTimeout(chatclick);
	layout.toggleClass("chat-enabled");
  chatArea.attr("aria-expanded", (chatArea.attr("aria-expanded") === "true" ? "false" : "true"));
  //chatArea.attr("aria-hidden", (chatArea.attr("aria-hidden") === "true" ? "false" : "true"));
	chat.toggleClass("active", layout.hasClass("chat-enabled"));
  chatclick = setTimeout(function(){
    windowResized();
  }, 1100);
});

users.click(function() {
  if(userclick) clearTimeout(userclick);
	layout.toggleClass("users-enabled");
  usersArea.attr("aria-expanded", (usersArea.attr("aria-expanded") === "true" ? "false" : "true"));
  //usersArea.attr("aria-hidden", (usersArea.attr("aria-hidden") === "true" ? "false" : "true"));
	users.toggleClass("active", layout.hasClass("users-enabled"));
  userclick = setTimeout(function() {
    windowResized('users');
  }, 1100);
});

logoutBtn.click(function() { logout() });

$("#prev-slide-btn").click(function() { prevImg(); });
$("#next-slide-btn").click(function() { nextImg(); });
$("#tool-pan-btn").click(function() { changeTool('panzoom'); });
$("#tool-line-btn").click(function() { changeTool('line'); });
$("#tool-rect-btn").click(function() { changeTool('rect'); });
$("#tool-ellipse-btn").click(function() { changeTool('ellipse'); });
