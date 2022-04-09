import numpy as np 
import pandas as pd 
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from flask import Flask, render_template, request

app = Flask(__name__)

# df = pd.read_csv("https://docs.google.com/spreadsheets/d/1HjH89Ryw3NzT62sedvTC54_DqNkvRgTZn4XXTN4sZuM/export?format=csv&id=1HjH89Ryw3NzT62sedvTC54_DqNkvRgTZn4XXTN4sZuM&gid=1781495660")
df = pd.read_csv("Cleaned-Data (1).csv")

df.isnull().sum()

severity_columns = df.filter(like='Severity_').columns
df['Severity_None'].replace({1:'None',0:'No'},inplace =True)
df['Severity_Mild'].replace({1:'Mild',0:'No'},inplace =True)
df['Severity_Moderate'].replace({1:'Moderate',0:'No'},inplace =True)
df['Severity_Severe'].replace({1:'Severe',0:'No'},inplace =True)

df['Condition']=df[severity_columns].values.tolist()

def remove(lista):
    lista = set(lista) 
    lista.discard("No")
    final = ''.join(lista)
    return final

df['Condition'] = df['Condition'].apply(remove)

df.drop(severity_columns,axis=1,inplace=True)

X= df.drop(['Condition'],axis=1)
y= df['Condition']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

clf=RandomForestClassifier(n_estimators=1000, criterion='gini')
clf.fit(X_train,y_train)

@app.route('/', methods=['GET'])
def main():
    return "Test Test Test"

@app.route('/predict', methods=['POST', "GET"])
def scrapeData():

    v1 = request.args.get('v1')
    v2 = request.args.get('v2')
    v3 = request.args.get('v3')

    v4 = request.args.get('v4')
    v5 = request.args.get('v5')
    v6 = request.args.get('v6')

    v7 = request.args.get('v7')
    v8 = request.args.get('v8')
    v9 = request.args.get('v9')

    print(v1,v4,v6)

    if v1.capitalize == "NO":
        v1 = 0
    else:
        v1 = 1
    if v2.capitalize == "NO":
        v2 = 0
    else:
        v2 = 1
    if v3.capitalize == "NO":
        v3 = 0
    else:
        v3 = 1
    if v4.capitalize == "NO":
        v4 = 0
    else:
        v4 = 1
    if v5.capitalize == "NO":
        v5 = 0
    else:
        v5 = 1
    if v6.capitalize == "NO":
        v6 = 0
    else:
        v6 = 1
    if v7.capitalize == "NO":
        v7 = 0
    else:
        v7 = 1
    if v8.capitalize == "NO":
        v8 = 0
    else:
        v8 = 1
    if v9.capitalize == "NO":
        v9 = 0
    else:
        v9 = 1

    print(v1,v4,v6,v8,v9)

    y_pred=clf.predict([[v1, v2, v3, v4, v5, v6, v7, v8, v9]])
    print(y_pred[0])
    return y_pred[0]

if __name__ == "__main__":
    app.run(debug=True)
