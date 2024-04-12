const express = require("express");
const cors = require("cors");

const { loginUser, signUpUser, confirmSignUp } = require("./auth");
const { deployLightsail, deployMonolith } = require("./deployment");
const {
  getRegions,
  getAvailabilityZones,
  getBlueprintIds,
  getBundlesForRegion,
  getInstanceTypes,
  getKeyPairs,
  createKeyPair,
} = require("./awsData");

const { getDeploymentsData } = require("./fetchDeployments");

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

// API endpoint to fetch Lightsail bundle IDs for a region
app.get("/api/available-bundles/:region", async (req, res) => {
  const region = req.params.region;
  try {
    const availableBundles = await getBundlesForRegion(region);
    res.json({ success: true, data: availableBundles });
  } catch (error) {
    console.error("Error fetching available bundles:", error);
    res.status(500).json({ success: false, error: "Internal Server Error" });
  }
});

// Endpoint to fetch instance types
app.get("/api/instance-types/:region", async (req, res) => {
  const region = req.params.region;
  try {
    const instanceTypes = await getInstanceTypes(region);
    console.log("Fetched instance types", instanceTypes.length);
    res.json({ success: true, data: instanceTypes });
  } catch (error) {
    console.error("Error fetching instance types:", error);
    res.status(500).json({ error: "Failed to fetch instance types" });
  }
});

// API endpoint to fetch keypairs for a region
app.get("/api/keypairs/:region", async (req, res) => {
  const region = req.params.region;
  try {
    const availableKeyPairs = await getKeyPairs(region);
    res.json({ success: true, data: availableKeyPairs });
  } catch (error) {
    console.error("Error fetching available key-pairs:", error);
    res.status(500).json({ success: false, error: "Internal Server Error" });
  }
});

// API endpoint to create new key pair in selected region
app.post("/api/create-key-pair", async (req, res) => {
  const region = req.body.region;
  const keyPairName = req.body.keyPairName;
  try {
    const newKeyPairData = await createKeyPair(region, keyPairName);
    res.json({ success: true, data: newKeyPairData });
  } catch (error) {
    console.error("Error creating key pair:", error);
    res.status(500).json({ success: false, error: "Error creating key pair" });
  }
});

// API endpoint for deploying Lightsail
app.post("/api/deploy-lightsail", async (req, res) => {
  const {
    instanceName,
    region,
    availabilityZone,
    blueprint,
    publicSSH,
    instancePlan,
    userEmail,
  } = req.body;
  console.log("Data received:", req.body);

  try {
    const deploymentResult = await deployLightsail(
      instanceName,
      region,
      availabilityZone,
      blueprint,
      publicSSH,
      instancePlan,
      userEmail
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

// API endpoint for deploying Lightsail
app.post("/api/deploy-monolith", async (req, res) => {
  const {
    instanceName,
    region,
    availabilityZone,
    image,
    instanceType,
    keyPair,
    sshAllowed,
    httpAllowed,
    storage,
    dbType,
    phpVersion,
    webServer,
    userEmail,
  } = req.body;
  console.log("Data received for monolith deployment:", req.body);

  try {
    const deploymentResult = await deployMonolith(
      instanceName,
      region,
      availabilityZone,
      image,
      instanceType,
      keyPair,
      sshAllowed,
      httpAllowed,
      storage,
      dbType,
      phpVersion,
      webServer,
      userEmail
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
      message: "Error deploying Monolith",
      error: error.message,
    });
  }
});

// API endpoint to fetch deployment data filtered by user email
app.get("/api/deployments", async (req, res) => {
  try {
    const userEmail = req.query.userEmail;
    if (!userEmail) {
      return res.status(400).json({ error: "User email is required" });
    }
    const deploymentData = await getDeploymentsData(userEmail);
    res.json({ success: true, data: deploymentData });
  } catch (error) {
    console.error("Error fetching deployment data:", error);
    res.status(500).json({ success: false, error: "Internal Server Error" });
  }
});

// Start the server
const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
