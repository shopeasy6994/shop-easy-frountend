import math
from fastapi import FastAPI, Query, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List

# --- Create a FastAPI app instance ---
app = FastAPI()

# --- Configure CORS ---
# This allows your Flutter app (running on a different origin) to make requests
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, restrict this to your app's domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- Pydantic Models (for data validation and serialization) ---
class Product(BaseModel):
    id: str
    name: str
    description: str
    price: float
    imageUrl: str
    category: str
    stock: int
    mrp: float

class PaginatedResponse(BaseModel):
    total: int
    page: int
    limit: int
    hasNextPage: bool
    data: List[Product]

# --- In-Memory Fake Database ---
# Generate 300 fake products for demonstration
FAKE_PRODUCTS = [
    Product(
        id=str(i),
        name=f"Product {i}",
        description=f"This is the description for awesome product number {i}.",
        price=round(10.0 + i * 1.5, 2),
        mrp=round((10.0 + i * 1.5) * 1.25, 2), # 25% markup
        imageUrl=f"https://via.placeholder.com/150?text=Product+{i}",
        category="Sample Category",
        stock=100,
    )
    for i in range(1, 301)
]
# Create a dictionary for quick lookups
PRODUCTS_DB = {p.id: p for p in FAKE_PRODUCTS}

# --- API Endpoints ---
@app.get("/api/products", response_model=PaginatedResponse)
def get_products(
    page: int = Query(1, ge=1, description="Page number"),
    limit: int = Query(20, ge=1, le=100, description="Items per page"),
):
    """
    This endpoint returns a paginated list of products.
    """
    total_products = len(FAKE_PRODUCTS)
    start_index = (page - 1) * limit
    end_index = start_index + limit

    # Get the slice of products for the current page
    paginated_data = FAKE_PRODUCTS[start_index:end_index]

    # Determine if there is a next page
    has_next_page = end_index < total_products

    return {
        "total": total_products,
        "page": page,
        "limit": limit,
        "hasNextPage": has_next_page,
        "data": paginated_data,
    }

# --- A simple root endpoint for health checks ---
@app.get("/")
def read_root():
    return {"message": "Shop Easy Backend is running!"}

# --- Add placeholder auth endpoints to prevent 404 errors ---
class AuthRequest(BaseModel):
    email: str
    password: str

class User(BaseModel):
    id: str
    name: str
    email: str

class AuthResponse(BaseModel):
    token: str
    user: User

@app.post("/api/auth/login", response_model=AuthResponse)
def login(auth_request: AuthRequest):
    # This is a fake login. In a real app, you would validate the password.
    return {
        "token": "fake-jwt-token-for-testing",
        "user": {
            "id": "user123",
            "name": "Test User",
            "email": auth_request.email
        }
    }

@app.get("/api/products/{product_id}", response_model=Product)
def get_product_by_id(product_id: str):
    """
    This endpoint returns a single product by its ID.
    """
    product = PRODUCTS_DB.get(product_id)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    return product

# --- Full existing code for reference ---

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class PaginatedResponse(BaseModel):
    total: int
    page: int
    limit: int
    hasNextPage: bool
    data: List[Product]

class AuthRequest(BaseModel):
    email: str
    password: str

class User(BaseModel):
    id: str
    name: str
    email: str

class AuthResponse(BaseModel):
    token: str
    user: User

@app.get("/api/products", response_model=PaginatedResponse)
def get_products(page: int = Query(1, ge=1), limit: int = Query(20, ge=1, le=100)):
    total_products = len(FAKE_PRODUCTS)
    start_index = (page - 1) * limit
    end_index = start_index + limit
    paginated_data = FAKE_PRODUCTS[start_index:end_index]
    has_next_page = end_index < total_products
    return {"total": total_products, "page": page, "limit": limit, "hasNextPage": has_next_page, "data": paginated_data}

@app.get("/")
def read_root():
    return {"message": "Shop Easy Backend is running!"}

@app.post("/api/auth/login", response_model=AuthResponse)
def login(auth_request: AuthRequest):
    return {"token": "fake-jwt-token-for-testing", "user": {"id": "user123", "name": "Test User", "email": auth_request.email}}