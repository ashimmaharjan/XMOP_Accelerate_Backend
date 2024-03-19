const AWS = require("aws-sdk");

// Configure AWS SDK
AWS.config.update({ region: "ap-southeast-2" });

// Initialize Lightsail instance
const lightsail = new AWS.Lightsail();

// Define route handlers
async function getRegions() {
  try {
    const regions = await lightsail.getRegions().promise();
    return regions;
  } catch (error) {
    console.error("Error fetching regions:", error);
    throw error;
  }
}

async function getAvailabilityZones(region) {
  try {
    const ec2 = new AWS.EC2({ region });
    const availabilityZones = await ec2.describeAvailabilityZones().promise();
    const zoneNames = availabilityZones.AvailabilityZones.map(
      (zone) => zone.ZoneName
    );
    console.log("Returned zones data array:", zoneNames);
    return zoneNames;
  } catch (error) {
    console.error("Error fetching availability zones:", error);
    throw error;
  }
}

async function getBlueprintIds() {
  try {
    const blueprints = await lightsail.getBlueprints().promise();
    return blueprints;
  } catch (error) {
    console.error("Error fetching blueprint IDs:", error);
    throw error;
  }
}

async function getBundleIds() {
  try {
    const bundles = await lightsail.getBundles().promise();

    return bundles;
  } catch (error) {
    console.error("Error fetching bundle IDs:", error);
    throw error;
  }
}

module.exports = {
  getRegions,
  getAvailabilityZones,
  getBlueprintIds,
  getBundleIds,
};
