# XMOP Accelerate Backend User Manual

## Table of Contents
1. [Introduction](#introduction)
2. [Project Code Structure](#project-code-structure)
3. [Prerequisites](#prerequisites)
4. [Installation](#installation)
5. [Configuration](#configuration)
    - [Setting Up AWS Cognito](#setting-up-aws-cognito)
    - [Configure AWS CLI](#configure-aws-cli)
    - [Setting up S3 Bucket](#setting-up-s3-bucket)
6. [Running the Backend Server](#running-the-backend-server)

## Introduction
Welcome to the XMOP Accelerate Backend User Manual! This manual will guide you through setting up and running the backend server for XMOP Accelerate. The backend is built using Node.js with the Express.js framework. Key components and dependencies include:

- **Express.js**: A web application framework for Node.js, used to build the backend server.
- **Dependencies**:
  - `amazon-cognito-identity-js`: For user authentication using AWS Cognito.
  - `aws-sdk`: Official AWS SDK for JavaScript, for interaction with AWS services.
  - `cors`: Middleware for handling CORS requests.
  - `nodemon`: Utility for automatically restarting the server during development.

## Project Code Structure
The backend code structure is organized as follows:
- **Entry Point**: `server.js`
- **Components**:
  - `auth.js`: Handles user authentication (login, signup, verification).
  - `deployment.js`: Manages deployment functionalities.
  - `awsData.js`: Handles AWS data operations (regions, availability zones, etc.).
  - `fetchDeployments.js`: Fetches deployment data.
  
## Prerequisites
Before getting started, ensure you have the following prerequisites installed on your system:
- Node.js (version >= 12.x)
- npm (Node Package Manager)
- Git

## Installation
Follow these steps to install the XMOP Accelerate Backend:
1. Clone the repository:
 ```
 git clone https://github.com/ashimmaharjan/XMOP_Accelerate_Backend.git
 ```
2. Change to the project directory:
cd XMOP_Accelerate_Backend
3. Install dependencies:
   ```
   npm install
   ```

## Configuration
### Setting Up AWS Cognito
To set up AWS Cognito for user authentication:
1. **Create a User Pool**: 
- Log in to the AWS Management Console.
- Navigate to Amazon Cognito service.
- Follow the provided steps to create a user pool and obtain User Pool ID and Client ID.

2. **Update `auth.js`**: 
- Replace "YOUR_USER_POOL_ID" and "YOUR_CLIENT_ID" with the actual IDs obtained from AWS Cognito.

3. **Handle Login, Signup, and Verification**: 
- Utilize functions in `auth.js` for user authentication functionalities.

### Configure AWS CLI
To configure AWS CLI:
1. **Install AWS CLI**: Follow the installation instructions provided in the AWS documentation.
2. **Configure AWS CLI**: Run `aws configure` command in the terminal and provide necessary information.

### Setting up S3 Bucket
To set up an S3 bucket:
1. **Create an S3 Bucket**: 
- Sign in to the AWS Management Console.
- Navigate to S3 service.
- Follow the provided steps to create an S3 bucket.

2. **Update S3 Bucket Parameters in Code**: 
- Replace the Bucket parameter with the name of your user-created S3 bucket in `deployment.js` and `fetchDeployments.js`.

## Running the Backend Server
To run the backend server, execute the following command:
```
nodemon server
```
The server will be accessible at port 3001.
