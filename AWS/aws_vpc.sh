#!/bin/bash

#############################
# Description: Manage VPC in AWS
# - Create or destroy VPC and subnet
# - Verify prerequisites
##############################

# Variables
VPC_CIDR="10.0.0.0/16"
SUBNET_CIDR="10.0.1.0/24"
REGION=${2:-"us-east-1"}  # Allow region to be passed as the second argument
VPC_NAME="MyVPC"
SUBNET_NAME="MySubnet"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI could not be found. Please install it first."
    exit 1
fi

# Check if AWS CLI is configured
if ! aws sts get-caller-identity &> /dev/null; then
    echo "AWS CLI is not configured or credentials are invalid. Please configure it first."
    exit 1
fi

# Function to create resources
create_resources() {
    # Create VPC
    VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --region $REGION --query 'Vpc.VpcId' --output text 2>&1)
    if [ $? -ne 0 ]; then
        echo "Failed to create VPC. Error: $VPC_ID"
        exit 1
    fi
    echo "VPC created with ID: $VPC_ID"

    # Tag the VPC
    TAG_RESULT=$(aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=$VPC_NAME --region $REGION 2>&1)
    if [ $? -ne 0 ]; then
        echo "Failed to tag VPC. Error: $TAG_RESULT"
        exit 1
    fi
    echo "VPC tagged with Name: $VPC_NAME"

    # Create a public subnet
    SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_CIDR --region $REGION --query 'Subnet.SubnetId' --output text 2>&1)
    if [ $? -ne 0 ]; then
        echo "Failed to create subnet. Error: $SUBNET_ID"
        exit 1
    fi
    echo "Subnet created with ID: $SUBNET_ID"

    # Tag the subnet
    TAG_RESULT=$(aws ec2 create-tags --resources $SUBNET_ID --tags Key=Name,Value=$SUBNET_NAME --region $REGION 2>&1)
    if [ $? -ne 0 ]; then
        echo "Failed to tag subnet. Error: $TAG_RESULT"
        exit 1
    fi
    echo "Subnet tagged with Name: $SUBNET_NAME"

    # Output success
    echo "VPC and Subnet created successfully."
    echo "VPC ID: $VPC_ID"
    echo "Subnet ID: $SUBNET_ID"
    echo "VPC Name: $VPC_NAME"
    echo "Subnet Name: $SUBNET_NAME"
    echo "VPC CIDR: $VPC_CIDR"
    echo "Subnet CIDR: $SUBNET_CIDR"
    echo "Region: $REGION"
}

# Function to destroy resources
destroy_resources() {
    # Find VPC ID by name
    VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$VPC_NAME" --region $REGION --query 'Vpcs[0].VpcId' --output text 2>&1)
    if [ $? -ne 0 ] || [ "$VPC_ID" == "None" ]; then
        echo "Failed to find VPC with Name: $VPC_NAME. Error: $VPC_ID"
        exit 1
    fi
    echo "Found VPC with ID: $VPC_ID"

    # Find Subnet ID by name
    SUBNET_ID=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=$SUBNET_NAME" --region $REGION --query 'Subnets[0].SubnetId' --output text 2>&1)
    if [ $? -ne 0 ] || [ "$SUBNET_ID" == "None" ]; then
        echo "Failed to find Subnet with Name: $SUBNET_NAME. Error: $SUBNET_ID"
        exit 1
    fi
    echo "Found Subnet with ID: $SUBNET_ID"

    # Delete the subnet
    DELETE_SUBNET=$(aws ec2 delete-subnet --subnet-id $SUBNET_ID --region $REGION 2>&1)
    if [ $? -ne 0 ]; then
        echo "Failed to delete Subnet. Error: $DELETE_SUBNET"
        exit 1
    fi
    echo "Subnet deleted successfully."

    # Delete the VPC
    DELETE_VPC=$(aws ec2 delete-vpc --vpc-id $VPC_ID --region $REGION 2>&1)
    if [ $? -ne 0 ]; then
        echo "Failed to delete VPC. Error: $DELETE_VPC"
        exit 1
    fi
    echo "VPC deleted successfully."
}

# Main script logic
if [ "$1" == "create" ]; then
    create_resources
elif [ "$1" == "destroy" ]; then
    destroy_resources
else
    echo "Usage: $0 {create|destroy} [region]"
    exit 1
fi