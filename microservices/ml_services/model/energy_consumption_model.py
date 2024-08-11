import joblib
import numpy as np
from sklearn.preprocessing import StandardScaler

class EnergyConsumptionModel:
    def __init__(self, model_path):
        # Load the trained model and scaler
        self.model = joblib.load(model_path)
        self.scaler = joblib.load(model_path.replace('model.pkl', 'scaler.pkl'))
    
    def predict(self, input_features):
        """
        Predicts energy consumption based on input features.
        
        Parameters:
        - input_features (list): A list of feature values for prediction.
        
        Returns:
        - float: The predicted energy consumption.
        """
        # Ensure the input is a numpy array
        input_features = np.array(input_features).reshape(1, -1)
        
        # Scale the features
        input_features = self.scaler.transform(input_features)
        
        # Predict using the loaded model
        prediction = self.model.predict(input_features)
        
        return prediction[0]

if __name__ == "__main__":
    # Example usage
    model_path = 'model/energy_model.pkl'
    features = [1200, 30, 15]  # Example feature values
    
    energy_model = EnergyConsumptionModel(model_path)
    predicted_energy = energy_model.predict(features)
    
    print(f"Predicted energy consumption: {predicted_energy} kWh")
