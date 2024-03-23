const AWS = require("aws-sdk");

// Create an instance of the S3 service
const s3 = new AWS.S3();

async function getDeploymentsData(email) {
  try {
    // Retrieve deployment data from S3 bucket
    const params = {
      Bucket: "xmops-accelerate-team-6",
      Key: "deployments/deployments.json",
    };
    const { Body } = await s3.getObject(params).promise();
    const deploymentData = JSON.parse(Body.toString());

    // Filter deployment data by user email
    const filteredDeployments = deploymentData.filter(
      (deployment) => deployment.userEmail === email
    );

    return filteredDeployments;
  } catch (error) {
    console.error("Error fetching deployment data:", error);
    throw error;
  }
}

module.exports = {
  getDeploymentsData,
};
