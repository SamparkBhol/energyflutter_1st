# API Documentation

## Overview
This document provides a detailed description of the API endpoints available in the Community Energy Optimizer backend. The APIs handle user authentication, energy logging, energy trading, and retrieving user data.

## Base URL
- **Production**: `https://api.communityenergy.com`
- **Development**: `http://localhost:3000`

## Endpoints

### 1. **User Registration**
- **Endpoint**: `/api/register`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "username": "string",
    "password": "string"
  }
