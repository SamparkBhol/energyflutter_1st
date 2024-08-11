from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import tensorflow as tf
import numpy as np
import uvicorn

app = FastAPI()

# Load the pre-trained TensorFlow model
model = tf.keras.models.load_model('model/energy_model.h5')

class UsageData(BaseModel):
    recent_usage: float

class PredictionResponse(BaseModel):
    predicted_usage: float

@app.post("/predict", response_model=PredictionResponse)
async def predict_usage(data: UsageData):
    try:
        # Prepare input data
        input_data = np.array([[data.recent_usage]])
        
        # Make prediction
        prediction = model.predict(input_data)
        predicted_value = float(prediction[0][0])

        return PredictionResponse(predicted_usage=predicted_value)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction error: {str(e)}")

@app.get("/")
async def root():
    return {"message": "Welcome to the ML Service for Energy Prediction"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
