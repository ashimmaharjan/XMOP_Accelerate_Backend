const { exec } = require("child_process");
const path = require("path");
const AWS = require("aws-sdk");

// Create an instance of the S3 service
const s3 = new AWS.S3();

async function uploadDeploymentData(
  instanceName,
  architectureType,
  createdAt,
  instanceARN,
  ip,
  userEmail
) {
  const bucketName = "xmops-accelerate-team-6";
  const key = "deployments/deployments.json";

  try {
    let existingDeployments = [];

    // Read existing JSON file from S3 bucket if it exists
    try {
      const getObjectParams = { Bucket: bucketName, Key: key };
      const data = await s3.getObject(getObjectParams).promise();
      existingDeployments = JSON.parse(data.Body.toString());
    } catch (error) {
      if (error.code !== "NoSuchKey") {
        console.error("Error reading existing deployments:", error);
        throw error;
      }
    }

    // Append data of new deployment to existing deployments
    existingDeployments.push({
      instanceName,
      architectureType,
      createdAt,
      instanceARN,
      ip,
      userEmail,
    });

    // Write updated deployments back to the JSON file in the S3 bucket
    const uploadParams = {
      Bucket: bucketName,
      Key: key,
      Body: JSON.stringify(existingDeployments, null, 2),
      ContentType: "application/json",
    };
    await s3.upload(uploadParams).promise();

    console.log("Deployment data appended successfully.");
  } catch (error) {
    console.error("Error appending deployment data:", error);
    throw error;
  }
}

const deployLightsail = (
  instanceName,
  region,
  availabilityZone,
  blueprint,
  publicSSH,
  instancePlan,
  userEmail
) => {
  return new Promise((resolve, reject) => {
    const receivedInstanceName = instanceName;
    const receivedRegion = region;
    const receivedAvailabilityZone = availabilityZone;
    const receivedBlueprint = blueprint;
    const receivedPublicSSH = publicSSH;
    const receivedInstancePlan = instancePlan;

    if (
      !receivedInstanceName ||
      !receivedRegion ||
      !receivedAvailabilityZone ||
      !receivedBlueprint ||
      !receivedInstancePlan
    ) {
      console.error("Missing required inputs");
      reject({ success: false, message: "Missing required inputs" });
      return;
    }

    const terraformPath = path.join(__dirname, "Lightsail");

    console.log("Initializing Terraform...");
    exec(
      "terraform init",
      { cwd: terraformPath },
      (initError, initStdout, initStderr) => {
        if (initError) {
          console.error(`Error initializing Terraform: ${initError.message}`);
          reject({ success: false, message: "Error initializing Terraform" });
          return;
        }

        console.log("Terraform initialized successfully.");
        console.log("Planning and applying Terraform changes...");
        exec(
          `terraform apply -auto-approve -var="instance=${receivedInstanceName}" -var="region=${receivedRegion}" -var="availability_zone=${receivedAvailabilityZone}"  -var="instance_blueprintid=${receivedBlueprint}" -var="intance_key_pair=${receivedPublicSSH}" -var="instance_bundleid=${receivedInstancePlan}" -json`, // Add -json to output Terraform state as JSON
          { cwd: terraformPath },
          (applyError, applyStdout, applyStderr) => {
            if (applyError) {
              console.error(`Error applying Terraform: ${applyError.message}`);
              reject({
                success: false,
                message: "Error applying Terraform",
                error: applyError.message,
              });
              return;
            }

            console.log("Terraform Apply Output:");
            console.log(applyStdout);

            exec(
              `terraform show -json`,
              { cwd: terraformPath },
              (showError, showStdout, showStderr) => {
                if (showError) {
                  console.error(
                    `Error querying Terraform state: ${showError.message}`
                  );
                  reject({
                    success: false,
                    message: "Error querying Terraform state",
                    error: showError.message,
                  });
                  return;
                }

                const state = JSON.parse(showStdout);
                const ip = state.values.root_module.resources.find(
                  (resource) =>
                    resource.type === "aws_lightsail_static_ip" &&
                    resource.name === "static_ip"
                ).values.ip_address;

                // Extract instance ARN
                const instanceARN = state.values.root_module.resources.find(
                  (resource) =>
                    resource.type === "aws_lightsail_instance" &&
                    resource.name === "instance"
                ).values.arn;

                resolve({
                  success: true,
                  message: "Terraform execution completed",
                  ip: ip,
                });

                uploadDeploymentData(
                  receivedInstanceName,
                  "Lightsail",
                  new Date().toISOString(),
                  instanceARN,
                  ip,
                  userEmail
                )
                  .then(() =>
                    console.log(
                      "LightSail Deployment data uploaded successfully"
                    )
                  )
                  .catch((err) =>
                    console.error("Error uploading deployment data:", err)
                  );
              }
            );
          }
        );
      }
    );
  });
};

const deployMonolith = (
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
) => {
  return new Promise((resolve, reject) => {
    const receivedInstanceName = instanceName;
    const receivedRegion = region;
    const receivedAvailabilityZone = availabilityZone;
    const receivedImage = image;
    const receivedInstanceType = instanceType;
    const receivedKeyPair = keyPair;
    const receivedSSHAllowed = sshAllowed;
    const receivedHTTPAllowed = httpAllowed;
    const receivedStorage = storage;
    const receivedDBType = dbType;
    const receivedPHPVersion = phpVersion;
    const receivedWebServer = webServer;

    if (
      !receivedInstanceName ||
      !receivedRegion ||
      !receivedAvailabilityZone ||
      !receivedImage ||
      !receivedInstanceType ||
      !receivedKeyPair ||
      !receivedStorage ||
      !receivedDBType ||
      !receivedPHPVersion ||
      !receivedWebServer
    ) {
      console.error("Missing required inputs");
      reject({ success: false, message: "Missing required inputs" });
      return;
    }

    const allowSSH = receivedSSHAllowed === "true" ? true : false;
    const allowHTTP = receivedHTTPAllowed === "true" ? true : false;

    const terraformPath = path.join(__dirname, "Monolith");

    console.log("Initializing Terraform...");
    exec(
      "terraform init",
      { cwd: terraformPath },
      (initError, initStdout, initStderr) => {
        if (initError) {
          console.error(`Error initializing Terraform: ${initError.message}`);
          reject({ success: false, message: "Error initializing Terraform" });
          return;
        }

        console.log("Terraform initialized successfully.");
        console.log("Planning and applying Terraform changes...");
        exec(
          `terraform apply -auto-approve -var="instance_name=${receivedInstanceName}" -var="aws_region=${receivedRegion}" -var="subnet_availability_zone=${receivedAvailabilityZone}" -var="ami=${receivedImage}" -var="instance_type=${receivedInstanceType}" -var="db_type=${receivedDBType}" -var="key_name=${receivedKeyPair}" -var="storage_size=${receivedStorage}" -var="apache_version=${receivedWebServer}" -var="php_version=${receivedPHPVersion}" -var="allow_ssh=${allowSSH}" -var="allow_http=${allowHTTP}" -json`, // Add -json to output Terraform state as JSON
          { cwd: terraformPath },
          (applyError, applyStdout, applyStderr) => {
            if (applyError) {
              console.error(`Error applying Terraform: ${applyError.message}`);
              reject({
                success: false,
                message: "Error applying Terraform",
                error: applyError.message,
              });
              return;
            }

            console.log("Terraform Apply Output:");
            console.log(applyStdout);

            exec(
              `terraform show -json`,
              { cwd: terraformPath },
              (showError, showStdout, showStderr) => {
                if (showError) {
                  console.error(
                    `Error querying Terraform state: ${showError.message}`
                  );
                  reject({
                    success: false,
                    message: "Error querying Terraform state",
                    error: showError.message,
                  });
                  return;
                }

                const state = JSON.parse(showStdout);

                // Extract public IP address
                const ip = state.values.root_module.resources.find(
                  (resource) =>
                    resource.type === "aws_instance" &&
                    resource.name === "wordpress_instance"
                ).values.public_ip;

                // Extract instance ARN
                const instanceARN = state.values.root_module.resources.find(
                  (resource) =>
                    resource.type === "aws_instance" &&
                    resource.name === "wordpress_instance"
                ).values.arn;

                resolve({
                  success: true,
                  message: "Terraform execution completed",
                  ip: ip,
                });

                uploadDeploymentData(
                  receivedInstanceName,
                  "Monolith",
                  new Date().toISOString(),
                  instanceARN,
                  ip,
                  userEmail
                )
                  .then(() =>
                    console.log(
                      "Monolith Deployment data uploaded successfully"
                    )
                  )
                  .catch((err) =>
                    console.error("Error uploading deployment data:", err)
                  );
              }
            );
          }
        );
      }
    );
  });
};

module.exports = { deployLightsail, deployMonolith };
