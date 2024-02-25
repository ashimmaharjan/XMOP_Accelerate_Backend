const express = require("express");
const cors = require("cors");

const { loginUser } = require("./auth");

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

// Start the server
const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
