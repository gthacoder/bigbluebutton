(function () {

    "use strict";

    var Globals = require("../client/globals");

    describe("linkify", function() {

        it("does not modify simple message without URLs", function() {
            var input = "abc",
                output = "abc";
            expect(Globals.linkify(input)).toBe(output);
        });

        // URLs starting with www
        it("detects URL starting with www in the middle of a message", function() {
            var input = "blah-blah-blah www.mozilla.org blah-blah-blah",
                output = "blah-blah-blah <a href='event:http://www.mozilla.org'><u>www.mozilla.org</u></a> blah-blah-blah";
            expect(Globals.linkify(input)).toBe(output);
        });
        it("detects URL starting with www in the very beginning of a message", function() {
            var input = "www.mozilla.org blah-blah-blah",
                output = "<a href='event:http://www.mozilla.org'><u>www.mozilla.org</u></a> blah-blah-blah";
            expect(Globals.linkify(input)).toBe(output);
        });
        it("detects URL starting with www in the very end of a message", function() {
            var input = "blah-blah-blah www.mozilla.org",
                output = "blah-blah-blah <a href='event:http://www.mozilla.org'><u>www.mozilla.org</u></a>";
            expect(Globals.linkify(input)).toBe(output);
        });

        // URLs starting with http://
        it("detects URL starting with http:// in the middle of a message", function() {
            var input = "blah-blah-blah http://mozilla.org blah-blah-blah",
                output = "blah-blah-blah <a href='event:http://mozilla.org'><u>http://mozilla.org</u></a> blah-blah-blah";
            expect(Globals.linkify(input)).toBe(output);
        });
        it("detects URL starting with http:// in the very beginning of a message", function() {
            var input = "http://mozilla.org blah-blah-blah",
                output = "<a href='event:http://mozilla.org'><u>http://mozilla.org</u></a> blah-blah-blah";
            expect(Globals.linkify(input)).toBe(output);
        });
        it("detects URL starting with http:// in the very end of a message", function() {
            var input = "blah-blah-blah http://mozilla.org",
                output = "blah-blah-blah <a href='event:http://mozilla.org'><u>http://mozilla.org</u></a>";
            expect(Globals.linkify(input)).toBe(output);
        });

        // URLs starting with https://
        it("detects URL starting with https:// in the middle of a message", function() {
            var input = "blah-blah-blah https://mozilla.org blah-blah-blah",
                output = "blah-blah-blah <a href='event:https://mozilla.org'><u>https://mozilla.org</u></a> blah-blah-blah";
            expect(Globals.linkify(input)).toBe(output);
        });
        it("detects URL starting with https:// in the very beginning of a message", function() {
            var input = "https://mozilla.org blah-blah-blah",
                output = "<a href='event:https://mozilla.org'><u>https://mozilla.org</u></a> blah-blah-blah";
            expect(Globals.linkify(input)).toBe(output);
        });
        it("detects URL starting with https:// in the very end of a message", function() {
            var input = "blah-blah-blah https://mozilla.org",
                output = "blah-blah-blah <a href='event:https://mozilla.org'><u>https://mozilla.org</u></a>";
            expect(Globals.linkify(input)).toBe(output);
        });

        // URLs starting with http://www
        it("detects URL starting with http://www in the middle of a message", function() {
            var input = "blah-blah-blah http://www.mozilla.org blah-blah-blah",
                output = "blah-blah-blah <a href='event:http://www.mozilla.org'><u>http://www.mozilla.org</u></a> blah-blah-blah";
            expect(Globals.linkify(input)).toBe(output);
        });
        it("detects URL starting with http://www in the very beginning of a message", function() {
            var input = "http://www.mozilla.org blah-blah-blah",
                output = "<a href='event:http://www.mozilla.org'><u>http://www.mozilla.org</u></a> blah-blah-blah";
            expect(Globals.linkify(input)).toBe(output);
        });
        it("detects URL starting with http://www in the very end of a message", function() {
            var input = "blah-blah-blah http://www.mozilla.org",
                output = "blah-blah-blah <a href='event:http://www.mozilla.org'><u>http://www.mozilla.org</u></a>";
            expect(Globals.linkify(input)).toBe(output);
        });

        // URLs starting with https://www
        it("detects URL starting with https://www in the middle of message", function() {
            var input = "blah-blah-blah https://www.mozilla.org blah-blah-blah",
                output = "blah-blah-blah <a href='event:https://www.mozilla.org'><u>https://www.mozilla.org</u></a> blah-blah-blah";
            expect(Globals.linkify(input)).toBe(output);
        });

        it("detects multiple URLs of different types", function() {
            var input = "blah-blah-blah www.mozilla.org blah-blah-blah http://www.redhat.com blah-blah-blah",
                output = "blah-blah-blah <a href='event:http://www.mozilla.org'><u>www.mozilla.org</u></a> blah-blah-blah <a href='event:http://www.redhat.com'><u>http://www.redhat.com</u></a> blah-blah-blah";
            expect(Globals.linkify(input)).toBe(output);
        });

        it("detects complicated URLs (Google Maps)", function() {
            var input = "blah-blah-blah https://www.google.com/maps/place/70+The+Pond+Rd,+York+University,+North+York,+ON+M3J+3M6,+Canada/@43.7708708,-79.4992517,17z/data=!3m1!4b1!4m2!3m1!1s0x882b2e246557eb79:0x2f69194a4df3c328 blah-blah-blah",
                output = "blah-blah-blah <a href='event:https://www.google.com/maps/place/70+The+Pond+Rd,+York+University,+North+York,+ON+M3J+3M6,+Canada/@43.7708708,-79.4992517,17z/data=!3m1!4b1!4m2!3m1!1s0x882b2e246557eb79:0x2f69194a4df3c328'><u>https://www.google.com/maps/place/70+The+Pond+Rd,+York+University,+North+York,+ON+M3J+3M6,+Canada/@43.7708708,-79.4992517,17z/data=!3m1!4b1!4m2!3m1!1s0x882b2e246557eb79:0x2f69194a4df3c328</u></a> blah-blah-blah";
            expect(Globals.linkify(input)).toBe(output);
        });

    });

    describe("Template.message.toClickable", function() {

        it("does nothing with a message not containing anchor tags", function() {
            var input = "abc",
                output = "abc";
            expect(Template.message.toClickable(input)).toBe(output);
        });

        it("modifies the message received from the Meteor client (single quotes)", function() {
            var input = "<a href='event:http://www.redhat.com/'><u>http://www.redhat.com/</u></a>",
                output = "<a target='_blank' href='http://www.redhat.com/'><u>http://www.redhat.com/</u></a>";
            expect(Template.message.toClickable(input)).toBe(output);
        });

        it("modifies the message received from the Meteor client; multiple anchor tags with single quotes", function() {
            var input = "blah-blah-blah <a href='event:http://www.redhat.com/'><u>http://www.redhat.com/</u></a> blah-blah-blah <a href='event:http://www.mozilla.org/'><u>http://www.mozilla.org/</u></a> blah-blah-blah",
                output = "blah-blah-blah <a target='_blank' href='http://www.redhat.com/'><u>http://www.redhat.com/</u></a> blah-blah-blah <a target='_blank' href='http://www.mozilla.org/'><u>http://www.mozilla.org/</u></a> blah-blah-blah";
            expect(Template.message.toClickable(input)).toBe(output);
        });

        it("modifies the message received from the Flash client (double quotes)", function() {
            var input = '<a href="event:http://www.redhat.com/"><u>http://www.redhat.com/</u></a>',
                output = '<a target="_blank" href="http://www.redhat.com/"><u>http://www.redhat.com/</u></a>';
            expect(Template.message.toClickable(input)).toBe(output);
        });

        it("modifies the message received from the Flash client; multiple anchor tags in double quotes", function() {
            var input = 'blah-blah-blah <a href="event:http://www.redhat.com/"><u>http://www.redhat.com/</u></a> blah-blah-blah <a href="event:http://www.mozilla.org/"><u>http://www.mozilla.org/</u></a> blah-blah-blah',
                output = 'blah-blah-blah <a target="_blank" href="http://www.redhat.com/"><u>http://www.redhat.com/</u></a> blah-blah-blah <a target="_blank" href="http://www.mozilla.org/"><u>http://www.mozilla.org/</u></a> blah-blah-blah';
            expect(Template.message.toClickable(input)).toBe(output);
        });

    });

})();
