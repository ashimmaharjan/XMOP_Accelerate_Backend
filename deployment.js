const { exec } = require("child_process");
const path = require("path");

const deployLightsail = (region, blueprint, instancePlan) => {
  return new Promise((resolve, reject) => {
    const receivedRegion = region;
    const receivedBlueprint = blueprint;
    const receivedInstancePlan = instancePlan;

    // Ensure all required inputs are provided
    if (!receivedRegion || !receivedBlueprint || !receivedInstancePlan) {
      console.error("Missing required inputs");
      reject({ success: false, message: "Missing required inputs" });
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
          `terraform apply -auto-approve -var="region=${receivedRegion}" -var="instance_blueprintid=${receivedBlueprint}" -var="instance_bundleid=${receivedInstancePlan}"`,
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

            const ipRegex = /instance_ip = "(.*?)"/;
            const match = applyStdout.match(ipRegex);
            const ip = match ? match[1] : undefined;

            resolve({
              success: true,
              message: "Terraform execution completed",
              ip: ip,
            });
          }
        );
      }
    );
  });
};

module.exports = { deployLightsail };
