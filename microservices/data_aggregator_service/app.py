from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List
import requests
import datetime
import numpy as np

app = FastAPI()

class UsageData(BaseModel):
    user_id: str
    timestamp: datetime.datetime
    usage: float  # kWh

class AggregatedData(BaseModel):
    average_usage: float
    total_usage: float
    timestamp: datetime.datetime

DATABASE = {}

@app.post("/add_usage")
async def add_usage(data: UsageData):
    try:
        user_data = DATABASE.get(data.user_id, [])
        user_data.append({"timestamp": data.timestamp, "usage": data.usage})
        DATABASE[data.user_id] = user_data
        return {"message": "Usage data added successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error adding usage data: {str(e)}")

@app.get("/aggregate/{user_id}")
async def aggregate_data(user_id: str):
    try:
        user_data = DATABASE.get(user_id, [])
        if not user_data:
            raise HTTPException(status_code=404, detail="No usage data found for this user")

        usage_values = [entry["usage"] for entry in user_data]
        total_usage = sum(usage_values)
        average_usage = total_usage / len(usage_values)
        latest_timestamp = max([entry["timestamp"] for entry in user_data])

        aggregated_data = AggregatedData(
            average_usage=average_usage,
            total_usage=total_usage,
            timestamp=latest_timestamp
        )
        return aggregated_data
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error aggregating data: {str(e)}")

@app.post("/aggregate_multiple")
async def aggregate_multiple(user_ids: List[str]):
    try:
        total_usage = 0.0
        total_entries = 0
        latest_timestamp = None

        for user_id in user_ids:
            user_data = DATABASE.get(user_id, [])
            usage_values = [entry["usage"] for entry in user_data]
            total_usage += sum(usage_values)
            total_entries += len(usage_values)
            user_latest = max([entry["timestamp"] for entry in user_data], default=None)
            if latest_timestamp is None or (user_latest and user_latest > latest_timestamp):
                latest_timestamp = user_latest

        if total_entries == 0:
            raise HTTPException(status_code=404, detail="No usage data found for the provided users")

        average_usage = total_usage / total_entries
        aggregated_data = AggregatedData(
            average_usage=average_usage,
            total_usage=total_usage,
            timestamp=latest_timestamp
        )
        return aggregated_data
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error aggregating data for multiple users: {str(e)}")

@app.post("/notify_ml_service")
async def notify_ml_service(user_id: str):
    try:
        aggregate_response = await aggregate_data(user_id)
        ml_service_url = "http://ml_service:8000/predict"
        payload = {"recent_usage": aggregate_response.average_usage}
        response = requests.post(ml_service_url, json=payload)
        if response.status_code != 200:
            raise HTTPException(status_code=response.status_code, detail="Error in ML service")
        return response.json()
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error notifying ML service: {str(e)}")

@app.get("/")
async def root():
    return {"message": "Welcome to the Data Aggregator Service"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8002)
