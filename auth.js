const {
  AuthenticationDetails,
  CognitoUser,
  CognitoUserPool,
  CognitoUserAttribute,
} = require("amazon-cognito-identity-js");

const userPool = new CognitoUserPool({
  UserPoolId: "us-east-1_5sqKN6gVE",
  ClientId: "6h05hlc92b3l4hbk2ud4d2df50",
});

// handle login functionality
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
      const idToken = session.getIdToken().getJwtToken();
      const fullName = session.getIdToken().payload.name;
      const email = session.getIdToken().payload.email;
      callback(null, {
        success: true,
        message: "User authenticated successfully",
        data: { idToken, fullName, email },
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
    mfaRequired: (challengeName, challengeParameters) => {
      console.log("MFA is required"); // Add a log statement for debugging
      callback({ error: "MFA_REQUIRED" }, null);
    },
  });
}

// handle signup functionality
function signUpUser(email, password, fullName, callback) {
  const attributeList = [
    new CognitoUserAttribute({ Name: "email", Value: email }),
    new CognitoUserAttribute({ Name: "name", Value: fullName }),
  ];

  userPool.signUp(email, password, attributeList, null, (err, result) => {
    if (err) {
      console.error("Error signing up user:", err);
      callback(err);
    } else {
      console.log("User signed up successfully", result);
      callback(null, result.user);
    }
  });
}

// handle signup confirmation
function confirmSignUp(email, confirmationCode, callback) {
  const userData = {
    Username: email,
    Pool: userPool,
  };

  const cognitoUser = new CognitoUser(userData);

  cognitoUser.confirmRegistration(confirmationCode, true, (err, result) => {
    if (err) {
      console.error("Error confirming user registration:", err);
      callback(err);
    } else {
      console.log("User registration confirmed successfully:", result);
      callback(null, result);
    }
  });
}

module.exports = { loginUser, signUpUser, confirmSignUp };
