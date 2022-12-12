from faker import Faker

# To create a json file
import json		

# For student id
from random import randint	

fake = Faker()

def input_data(x):

	# dictionary
	student_data ={}
	for i in range(0, x):
		student_data[i]={}
		student_data[i]['id']= randint(1, 100)
		student_data[i]['name']= fake.name()
		student_data[i]['address']= fake.address()
		student_data[i]['credit card']= fake.credit_card_number()
	print(student_data)

	# dictionary dumped as json in a json file
	with open('customerInfo.json', 'w') as fp:
		json.dump(student_data, fp)
	

def main():

	# Enter number of students
	number_of_students = 30
	input_data(number_of_students)
main()
# The folder or location where this python code
# is save there a students.json will be created
# having 10 students data.

