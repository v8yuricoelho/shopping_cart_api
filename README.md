# Shopping Cart API

A modern Shopping Cart API built with **Ruby on Rails**

---

## 📋 Overview

This application provides the following shopping cart features:
- Add products to a cart.
- Update item quantities in a cart.
- Remove items from a cart.
- Mark carts as abandoned and clean them after a defined period.
- Persistent data storage in **PostgreSQL**.
- **Redis** for asynchronous task management with **Sidekiq**.

---

## 🛠 Technologies Used

- **Ruby on Rails** (version 7.1.5)
- **PostgreSQL** (database)
- **Redis** (jobs)
- **Sidekiq** and **Sidekiq-Scheduler** (asynchronous processing)
- **Docker/Docker Compose** (containerized environment)

---

## 🚀 Getting Started

### **Requirements**

Ensure you have **Docker** and **Docker Compose** installed on your machine.

### **Steps**

1. **Clone the repository:**
  ```bash
  git clone https://github.com/v8yuricoelho/shopping_cart_api.git
  cd shopping_cart_api

2. **Start the containers:**
  ```bash
  docker-compose up --build

3. **Access the application:**
  ```bash
  The API will be available at: http://localhost:3000

4. **Seed the database:**
  ```bash
  docker-compose exec web bin/rails db:seed

5. **Run tests:**
  ```bash
  docker-compose run test
