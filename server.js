const express = require("express");
const cors = require("cors");

const { loginUser, signUpUser, confirmSignUp } = require("./auth");

const app = express();

app.use(cors());
// Middleware to parse JSON request bodies
app.use(express.json());

// Route to handle login request
app.post("/api/login", (req, res) => {
  const email = req.body.email;
  const password = req.body.password;

  // Call the loginUser function from auth.js
  loginUser(email, password, (err, result) => {
    if (err) {
      res.status(401).json(result);
    } else {
      res.json(result);
    }
  });
});

// Route to handle signup request
app.post("/api/signup", (req, res) => {
  const { email, password, fullName } = req.body;

  signUpUser(email, password, fullName, (err, user) => {
    if (err) {
      res.status(500).json({ error: err.message || "Error signing up user" });
    } else {
      res.status(200).json({ message: "User signed up successfully", user });
    }
  });
});

// Route to handle confirmation request
app.post("/api/verifyAccount", (req, res) => {
  const { email, confirmationCode } = req.body;

  confirmSignUp(email, confirmationCode, (err, result) => {
    if (err) {
      res
        .status(400)
        .json({ error: "Error confirming user registration", details: err });
    } else {
      res
        .status(200)
        .json({ message: "User registration confirmed successfully", result });
    }
  });
});

// Start the server
const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
