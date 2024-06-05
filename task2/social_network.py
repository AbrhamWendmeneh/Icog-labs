# importing packages
import os
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from neo4j import GraphDatabase
import uvicorn
import threading
from dotenv import load_dotenv

# load environment variables
load_dotenv()

# Neo4j connection
URI = os.getenv("NEO4J_URI")
AUTH = os.getenv("NEO4J_AUTH"), os.getenv("NEO4J_PASSWORD")

driver = GraphDatabase.driver(URI, auth=AUTH)

# FastAPI instance
app = FastAPI()

class User(BaseModel):
    name: str
    age: int
    location: str
    interests: str

class UpdateUser(BaseModel):
    name: str = None
    age: int = None
    location: str = None
    interests: str = None
    
class FriendRequest(BaseModel):
    from_user: str
    to_user: str
    
def run_query(query, parameters =None):
    with driver.session() as session:
        result = session.run(query, parameters)
        return result.data()
    
# create user 
@app.post("/users/")
@app.post("/users/")
def create_user(user:User):
    query = """
            CREATE (userVal:User {name: $name, age: $age, location: $location, interests: $interests})
            RETURN userVal
            """
    params = user.dict()
    result = run_query(query, params)
    return result

# update user information
@app.put("/users/{name}")
def update_user(name: str, update: UpdateUser):
    query = """
    MATCH (user:User {name: $name})
    SET user += $update
    RETURN user
    """
    params = {"name": name, "updates": {k: v for k, v in update.dict().items() if v is not None}}
    result = run_query(query, params)
    if not result:
        raise HTTPException(status_code=404, detail="User not found")
    return result

# Friend management: Add Friend
@app.post("/friends/")
def add_friend(friend_request: FriendRequest):
    query = """
    MATCH (a:User {name: $from_user}), (b:User {name: $to_user})
    MERGE (a)-[:FRIENDS_WITH]->(b)
    RETURN a, b
    """
    params = friend_request.dict()
    result = run_query(query, params)
    if not result:
        raise HTTPException(status_code=404, detail="User not found")
    return result

# Friend management: Remove Friend
@app.delete("/friends/")
def remove_friend(friend_request: FriendRequest):
    query = """
    MATCH (a:User {name: $from_user})-[r:FRIENDS_WITH]->(b:User {name: $to_user})
    DELETE r
    RETURN a, b
    """
    params = friend_request.dict()
    result = run_query(query, params)
    if not result:
        raise HTTPException(status_code=404, detail="Friendship not found")
    return result

# Friend recommendation
@app.get("/recommend_friends/{name}")
def recommend_friends(name:str):
    query = """
    MATCH (user:User {name: $name})-[:FRIENDS_WITH]-(friend)-[:FRIENDS_WITH]-(recommendation)
    WHERE NOT (user)-[:FRIENDS_WITH]-(recommendation) AND user <> recommendation
    RETURN recommendation
    """
    params = {"name": name}
    result = run_query(query, params)
    if not result:
        raise HTTPException(status_code=404, detail="No recommendations found")
    return result

# User search
@app.get("/users/search/")
def search_users(name:str = None, location:str = None, interests:str = None):
    query = """
    MATCH (user:User)
    WHERE user.name = $name OR user.location = $location OR user.interests = $interests
    RETURN user
    """
    params = {"name": name, "location": location, "interests": interests}
    result = run_query(query, params)
    if not result:
        raise HTTPException(status_code=404, detail="No users found")
    return result

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)  