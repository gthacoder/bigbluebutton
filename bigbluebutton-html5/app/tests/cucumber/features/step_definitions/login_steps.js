(function() {
  'use strict';

  var assert = require('assert');
  var ip = require('ip'); // to get the server's external IP address

  module.exports = function() {
    var helper = this;
    this.When(/^I navigate to the landing page$/, function(callback) {
      helper.world.browser.url('http://' + ip.address()).call(callback);
    });
    this.Then(/^I should see the title of "([^"]*)"$/, function(expectedTitle, callback) {
      helper.world.browser.title(function(err, res) {
        assert.equal(res.value, expectedTitle);
        callback();
      });
    });
  };
})();

