
# Generating Custom Data
The customerInfo.json file can be used for importing data into the SQS queue. However, generate_data.py can generate new CustomerInfo data.

## Install Faker
Before running generate_data.py, please be sure to install the Fake library.
* pip install Faker


## Copy files
Copy the following files to the EC2 instance
* fast_producer.py
* customerInfo.json
* queue_status.py
* slow_producer.py
* purge_queue.py
* sqs_url.py

Copy EC2_files.zip to EC2 instance
* scp -i ~/Downloads/pem-file.pem ~/Documents/sqs-queue-demo/ec2_files.zip ec2-user@XX.XX.XX.XX:/home/ec2-user

Install python on EC2 instance
* sudo yum install python37 -y
* sudo yum install python -y
* wget https://bootstrap.pypa.io/get-pip.py
* python3 get-pip.py
* pip install boto3

# Create SQS Queue
python3 create_queue.py

# Get SQS endpoint and update SQS_url.py file
* aws sqs get-queue-url --queue-name mynewq
* vi SQS_URL.py
* update link

# Demo
* run python3 slow_producer.py
* Check SQS in AWS Console
* OR run python3 queue_status.py

# Delete SQS queue
* Be sure to delete manual SQS queue, since it was made with Python