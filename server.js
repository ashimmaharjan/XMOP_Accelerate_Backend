const express = require("express");
const cors = require("cors");

const { loginUser, signUpUser, confirmSignUp } = require("./auth");
const { deployLightsail } = require("./deployment");
const {
  getRegions,
  getAvailabilityZones,
  getBlueprintIds,
  getBundleIds,
} = require("./awsData");

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

// API endpoint for deploying Lightsail
app.post("/api/deploy-lightsail", async (req, res) => {
  const { region, blueprint, instancePlan } = req.body;
  console.log("Data received:", req.body);

  try {
    const deploymentResult = await deployLightsail(
      region,
      blueprint,
      instancePlan
    );
    if (deploymentResult.success) {
      res.status(200).json({
        success: true,
        message: "Terraform execution completed",
        ip: deploymentResult.ip,
      });
    } else {
      res.status(500).json({
        success: false,
        message: "Error applying Terraform",
        error: deploymentResult.error,
      });
    }
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Error deploying Lightsail",
      error: error.message,
    });
  }
});

// API endpoint to fetch AWS regions
app.get("/api/regions", async (req, res) => {
  try {
    const regions = await getRegions();
    res.json({ success: true, data: regions });
  } catch (error) {
    console.error("Error fetching regions:", error);
    res.status(500).json({ success: false, error: "Internal Server Error" });
  }
});

// API endpoint to fetch availability zones for a region
app.get("/api/availability-zones/:region", async (req, res) => {
  const region = req.params.region;
  try {
    const availabilityZones = await getAvailabilityZones(region);
    res.json({ success: true, data: availabilityZones });
  } catch (error) {
    console.error("Error fetching availability zones:", error);
    res.status(500).json({ success: false, error: "Internal Server Error" });
  }
});

// API endpoint to fetch Lightsail blueprint IDs
app.get("/api/blueprints", async (req, res) => {
  try {
    const blueprints = await getBlueprintIds();
    res.json({ success: true, data: blueprints });
  } catch (error) {
    console.error("Error fetching blueprint IDs:", error);
    res.status(500).json({ success: false, error: "Internal Server Error" });
  }
});

// API endpoint to fetch Lightsail bundle IDs
app.get("/api/bundles", async (req, res) => {
  try {
    const bundles = await getBundleIds();
    res.json({ success: true, data: bundles });
  } catch (error) {
    console.error("Error fetching bundle IDs:", error);
    res.status(500).json({ success: false, error: "Internal Server Error" });
  }
});

// Start the server
const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
