
import json
import numpy as np 
import pandas as pd 
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from flask import Flask, render_template, request

app = Flask(__name__)

df = pd.read_excel (r'3 covid types.xlsx')


x= df.iloc[:,0:-1]
y =df.iloc[:,-1]

# shoulders
X_train, X_test, y_train, y_test = train_test_split(x, y, test_size=0.2, random_state=2020)
 
print('Shape of X_train = ', X_train.shape)
print('Shape of y_train = ', y_train.shape)
print('Shape of X_test = ', X_test.shape)
print('Shape of y_test = ', y_test.shape)


#shoulder

classifier=RandomForestClassifier(n_estimators=40, criterion='gini')
classifier.fit(X_train,y_train)

classifier.score(X_test,y_test)

@app.route('/')
def main():
    return "<h1>Eet eez Ronniingg</h1>"


@app.route('/predict', methods=['POST', "GET"])
def predict():

    v1 = request.args.get('v1')
    v2 = request.args.get('v2')
    v3 = request.args.get('v3')

    v4 = request.args.get('v4')
    v5 = request.args.get('v5')
    v6 = request.args.get('v6')

    v7 = request.args.get('v7')
    v8 = request.args.get('v8')
    v9 = request.args.get('v9')

    if v1 == "no":
        v1 = 0
    else:
        v1 = 1
    if v2 == "no":
        v2 = 0
    else:
        v2 = 1
    if v3 == "no":
        v3 = 0
    else:
        v3 = 1
    if v4 == "no":
        v4 = 0
    else:
        v4 = 1
    if v5 == "no":
        v5 = 0
    else:
        v5 = 1
    if v6 == "no":
        v6 = 0
    else:
        v6 = 1
    if v7 == "no":
        v7 = 0
    else:
        v7 = 1
    if v8 == "no":
        v8 = 0
    else:
        v8 = 1
    if v9 == "no":
        v9 = 0
    else:
        v9 = 1

    Root_Cause= [v1,v2,v3,v4,v5,v6,v7,v8,v9]

    Root_Cause = np.array([Root_Cause])
    print(Root_Cause)

    y_pred = classifier.predict(Root_Cause)
    # result = y_pred[0]
    # toSend = f'{result}'
    print(y_pred[0])
    return {"result": f'{y_pred[0]}'}

# @app.route('/predict', methods=['POST', "GET"])
# def scrapeData():

#     v1 = request.args.get('v1')
#     v2 = request.args.get('v2')
#     v3 = request.args.get('v3')

#     v4 = request.args.get('v4')
#     v5 = request.args.get('v5')
#     v6 = request.args.get('v6')

#     v7 = request.args.get('v7')
#     v8 = request.args.get('v8')
#     v9 = request.args.get('v9')

#     print(v1,v4,v6)

#     if v1.capitalize == "NO":
#         v1 = 0
#     else:
#         v1 = 1
#     if v2.capitalize == "NO":
#         v2 = 0
#     else:
#         v2 = 1
#     if v3.capitalize == "NO":
#         v3 = 0
#     else:
#         v3 = 1
#     if v4.capitalize == "NO":
#         v4 = 0
#     else:
#         v4 = 1
#     if v5.capitalize == "NO":
#         v5 = 0
#     else:
#         v5 = 1
#     if v6.capitalize == "NO":
#         v6 = 0
#     else:
#         v6 = 1
#     if v7.capitalize == "NO":
#         v7 = 0
#     else:
#         v7 = 1
#     if v8.capitalize == "NO":
#         v8 = 0
#     else:
#         v8 = 1
#     if v9.capitalize == "NO":
#         v9 = 0
#     else:
#         v9 = 1

#     print(v1,v4,v6,v8,v9)

#     y_pred=clf.predict([[v1, v2, v3, v4, v5, v6, v7, v8, v9]])
#     print(y_pred[0])
#     return {"result": y_pred[0]}

if __name__ == "__main__":
    app.run(debug=True)
