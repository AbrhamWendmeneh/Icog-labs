import requests

# Base URL of the FastAPI app
base_url = "http://127.0.0.1:8000"

# Create a user
response = requests.post(
    f"{base_url}/users/",
    json={"name": "John Doe", "age": 30, "location": "New York", "interests": "AI, Programming"}
)
print("Create User:", response.json())

# Update a user
response = requests.put(
    f"{base_url}/users/John Doe",
    json={"location": "San Francisco"}
)
print("Update User:", response.json())

# Add a friend
response = requests.post(
    f"{base_url}/friends/",
    json={"from_user": "John Doe", "to_user": "Jane Smith"}
)
print("Add Friend:", response.json())

# Remove a friend
response = requests.delete(
    f"{base_url}/friends/",
    json={"from_user": "John Doe", "to_user": "Jane Smith"}
)
print("Remove Friend:", response.json())

# Recommend friends
response = requests.get(f"{base_url}/recommend_friends/John Doe")
print("Recommend Friends:", response.json())

# Search users
response = requests.get(f"{base_url}/users/search/?name=John")
print("Search Users:", response.json())
