from webbrowser import get
from flask import Flask, jsonify, request 
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier


app = Flask(_name_)



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


@app.route('/predict/<v1>/<v2>/<v3>/<v4>/<v5>/<v6>/<v7>/<v8>/<v9>')
def predict(v1,v2,v3,v4,v5,v6,v7,v8,v9):
    Root_Cause= [v1,v2,v3,v4,v5,v6,v7,v8,v9]

    Root_Cause = np.array([Root_Cause])
    Root_Cause

    print(classifier.predict(Root_Cause)[0])
    return(classifier.predict(Root_Cause)[0])


if _name_ == '_main_':
    app.run(debug=True)