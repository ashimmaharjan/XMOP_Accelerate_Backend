import os
import boto3
import sys

def create_key_pair(key_name, project_dir):
    # Create an EC2 client
    ec2_client = boto3.client('ec2')

    # Check if key pair already exists
    existing_key_pairs = ec2_client.describe_key_pairs(KeyNames=[key_name])['KeyPairs']
    if existing_key_pairs:
        print(f"Key pair '{key_name}' already exists.")
        return

    # Create the key pair
    response = ec2_client.create_key_pair(KeyName=key_name)

    # Get the private key
    private_key = response['KeyMaterial']

    # Save the private key to a file in a known location
    key_dir = os.path.join(project_dir, 'keys')
    os.makedirs(key_dir, exist_ok=True)
    key_path = os.path.join(key_dir, f"{key_name}.pem")
    with open(key_path, 'w') as key_file:
        key_file.write(private_key)

    print(f"Key pair '{key_name}' created and saved to '{key_path}'")

if __name__ == "__main__":
    
    project_dir = os.path.dirname(os.path.abspath(__file__))
    if len(sys.argv) < 2:
        print("Error: Key name not provided as command-line argument")
        sys.exit(1)

    key_name = sys.argv[1]  # Retrieve the key_name from command line arguments
    create_key_pair(key_name, project_dir)
