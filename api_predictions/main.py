import json
from fastapi import FastAPI, Body


def read_json(file_name):
    f = open(
        file_name,
    )
    league = json.load(f)
    f.close()
    return league

app = FastAPI()  # pragma: no mutate

PATH_DATABASE = "data/predictions_78_2021_15.json"

@app.get("/")
def read_root():
    predictions = read_json(PATH_DATABASE)
    return predictions