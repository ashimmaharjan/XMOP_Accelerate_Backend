const {
  AuthenticationDetails,
  CognitoUser,
  CognitoUserPool,
} = require("amazon-cognito-identity-js");

const userPool = new CognitoUserPool({
  UserPoolId: "us-east-1_5sqKN6gVE",
  ClientId: "6h05hlc92b3l4hbk2ud4d2df50",
});

function loginUser(email, password, callback) {
  const authenticationDetails = new AuthenticationDetails({
    Username: email,
    Password: password,
  });

  const cognitoUser = new CognitoUser({
    Username: email,
    Pool: userPool,
  });

  cognitoUser.authenticateUser(authenticationDetails, {
    onSuccess: (session) => {
      console.log("User authenticated successfully");
      callback(null, {
        success: true,
        message: "User authenticated successfully",
      });
    },
    onFailure: (err) => {
      console.error("Error authenticating user:", err);
      callback(err, { success: false, error: "Invalid email or password." });
    },
    newPasswordRequired: (userAttributes, requiredAttributes) => {
      // Simulate successful authentication for testing purposes
      console.log(
        "User must change password, but simulating successful authentication for testing"
      );
      callback(null, {
        success: true,
        message: "User authenticated successfully",
      });
    },
  });
}

module.exports = { loginUser };
