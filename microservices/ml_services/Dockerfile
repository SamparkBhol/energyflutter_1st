# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir fastapi uvicorn tensorflow pydantic numpy

# Expose the port the app runs on
EXPOSE 8000

# Define environment variable
ENV MODEL_PATH /app/model/energy_model.h5

# Run the application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
