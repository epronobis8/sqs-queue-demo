
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
