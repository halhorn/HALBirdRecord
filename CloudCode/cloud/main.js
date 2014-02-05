var secret = require('cloud/secret.js');

var Mandrill = require('mandrill');
Mandrill.initialize(secret.get_mandorill_api_key());

Parse.Cloud.define("notify_student_authentication_request", function(request, response) {
  Mandrill.sendEmail({
    message: {
      from_email: "halhorn@halidi.com",
      from_name: "Bird Record",
      to: [
        {
          email: "halhorn@halmidi.com",
          name: "HAL"
        }
      ],
      subject: "HALBirdRecord - Student Authenticate Request",
      text: "You get student authentication request.\n\nhttps://parse.com/apps/halbirdrecord/collections"
    },
    async: true
  },{
    success: function(httpResponse) {
      console.log(httpResponse);
      response.success("Email sent!");
    },
    error: function(httpResponse) {
      console.error(httpResponse);
      response.error("Uh oh, something went wrong");
    }
  });
});
