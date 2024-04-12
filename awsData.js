const AWS = require("aws-sdk");

// Configure AWS SDK
AWS.config.update({ region: "ap-southeast-2" });

// Initialize Lightsail instance
const lightsail = new AWS.Lightsail();

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

async function getBundlesForRegion(region) {
  try {
    const lightsail = new AWS.Lightsail({ region });
    const bundles = await lightsail.getBundles().promise();
    return bundles;
  } catch (error) {
    console.error("Error fetching bundles for region:", error);
    throw error;
  }
}

async function getInstanceTypes(region) {
  try {
    const ec2 = new AWS.EC2({ region });
    const instanceTypes = await ec2.describeInstanceTypes().promise();

    // Filter instance types where VirtualizationTypes include "hvm" or "pv"
    const virtualServerTypes = instanceTypes.InstanceTypes.filter(
      (instance) =>
        instance.SupportedVirtualizationTypes.includes("hvm") ||
        instance.SupportedVirtualizationTypes.includes("pv")
    );

    // Sort the filtered instance types alphabetically based on their InstanceType property
    const sortedVirtualServerTypes = virtualServerTypes.sort((a, b) => {
      return a.InstanceType.localeCompare(b.InstanceType);
    });

    return sortedVirtualServerTypes;
  } catch (error) {
    console.error("Error fetching virtual server types:", error);
    throw error;
  }
}

async function getKeyPairs(region) {
  try {
    const ec2 = new AWS.EC2({ region });
    const keyPairsData = await ec2.describeKeyPairs().promise();
    return keyPairsData;
  } catch (error) {
    console.error("Error fetching key pairs:", error);
    throw error;
  }
}

async function createKeyPair(region, keyPairName) {
  try {
    const ec2 = new AWS.EC2({ region });
    const newKeyPairData = await ec2
      .createKeyPair({ KeyName: keyPairName })
      .promise();
    return newKeyPairData;
  } catch (error) {
    console.error("Error creating new key pair:", error);
    throw error;
  }
}

module.exports = {
  getRegions,
  getAvailabilityZones,
  getBlueprintIds,
  getBundlesForRegion,
  getInstanceTypes,
  getKeyPairs,
  createKeyPair,
};
