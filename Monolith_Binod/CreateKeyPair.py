import os
import boto3

def create_key_pair(key_name, project_dir):
    # Create an EC2 client
    ec2_client = boto3.client('ec2')

    # Create the key pair
    response = ec2_client.create_key_pair(KeyName=key_name)

    # Get the private key
    private_key = response['KeyMaterial']

    # Save the private key to a file
    key_path = os.path.join(project_dir, f"{key_name}.pem")
    with open(key_path, 'w') as key_file:
        key_file.write(private_key)

    print(f"Key pair '{key_name}' created and saved to '{key_path}'")

if __name__ == "__main__":
    key_name = input("Enter the name for the new key pair: ")
    project_dir = os.path.dirname(os.path.abspath(__file__))

    create_key_pair(key_name, project_dir)