#BMI Calculator with python 

name = input("Enter your name: ")
weight = int(input("Enter your weight in kilograms: "))

height = float(input("Enter your height in meters: "))

bmi = round(weight/height**2,2)
print(weight)
print(height)
print(name,"your BMI is ", bmi)
if 0 < bmi <= 18.5:
    print("You are underweight")
elif 18.5 < bmi <=24.9:
    print("You have normal weight")
elif 25 <= bmi <= 29.9:
    print("You are overweight")
elif bmi >= 30:
    print("You have obesity")
else:
    print("invalid input")

