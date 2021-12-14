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


@app.get("/{league_season_round}")
def read_root(league_season_round):
    predictions = read_json(f"data/predictions_{league_season_round}.json")
    return predictions