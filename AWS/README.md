# AWS VPC Management Script

## 📄 Description
This is a simple Bash script that, when provided with a command line argument, creates or destroys a VPC and subnet in AWS.

The script:
- Verifies AWS CLI installation and configuration
- Creates a VPC and subnet with custom CIDR ranges
- Tags the resources
- Deletes the VPC and subnet when needed

---

## ⚙️ Prerequisites
- AWS CLI must be installed and configured with proper credentials.  
  (Run `aws configure` if not already set up.)

- Necessary IAM permissions to:
  - Create and delete VPCs
  - Create and delete subnets
  - Manage resource tags

---

## 📦 Script Variables
| Variable      | Description                                   | Default Value     |
|---------------|-----------------------------------------------|-------------------|
| `VPC_CIDR`    | CIDR block for the VPC                        | `10.0.0.0/16`     |
| `SUBNET_CIDR` | CIDR block for the Subnet                     | `10.0.1.0/24`     |
| `REGION`      | AWS Region to deploy the resources            | `us-east-1` (default) |
| `VPC_NAME`    | Name tag assigned to the VPC                  | `MyVPC`           |
| `SUBNET_NAME` | Name tag assigned to the Subnet               | `MySubnet`        |

---

## 🚀 Usage

```bash
# Make the script executable
chmod +x aws_vpc.sh
```

### Create VPC and Subnet
```bash
./aws_vpc.sh create [region]
```
- `region` is optional (defaults to `us-east-1` if not provided).

**Example:**
```bash
./aws_vpc.sh create us-west-2
```

### Destroy VPC and Subnet
```bash
./aws_vpc.sh destroy [region]
```

**Example:**
```bash
./aws_vpc.sh destroy us-west-2
```

---

## ✅ Output
When you **create** resources, you'll see:
- VPC ID
- Subnet ID
- Resource Names
- CIDR details
- Region

When you **destroy** resources, you'll see:
- Deletion confirmation for Subnet and VPC

---

## 📌 Notes
- The script searches for VPC and Subnet using their `Name` tags when deleting.
- Error handling is included to catch common failures (like missing AWS CLI, invalid credentials, etc.).

---

## 📋 Example Session

```bash
$ ./aws_vpc.sh create
AWS CLI is installed.
VPC created with ID: vpc-0abcd1234ef567890
VPC tagged with Name: MyVPC
Subnet created with ID: subnet-0abcd1234ef567890
Subnet tagged with Name: MySubnet
VPC and Subnet created successfully.
```
![image](https://github.com/user-attachments/assets/b63d8a80-9c9f-4a5a-ab30-90cfbf404452)
![image](https://github.com/user-attachments/assets/976551ca-f7f9-43f9-8238-554b83fd1204)


```bash
$ ./aws_vpc.sh destroy
Found VPC with ID: vpc-0abcd1234ef567890
Found Subnet with ID: subnet-0abcd1234ef567890
Subnet deleted successfully.
VPC deleted successfully.
```
![image](https://github.com/user-attachments/assets/b7b8c2ed-4814-4d04-8415-0b75f6e01bbd)


