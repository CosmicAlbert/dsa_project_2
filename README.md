# Public Transport Management System

A ** microservices-based system** for managing public transportation operations, including passenger management, ticketing, payments, and transport scheduling.

---

## System Architecture

This project follows a **microservices architecture** built with **Ballerina**, where each service operates independently and communicates via **REST APIs** and **Kafka messaging**.

### Services Overview

| Service | Description |
|----------|-------------|
| **Passenger Service** | Handles user registration, authentication, and profile management. |
| **Transport Service** | Manages transportation routes, trips, and scheduling. |
| **Ticketing Service** | Handles ticket creation, validation, and tracking. |
| **Payment Service** | Processes payments and manages payment history. |
| **Notification Service** | Sends real-time notifications to users. |
| **Admin Service** | Provides administrative and system management functionalities. |

---

## Prerequisites

Before running the system, ensure you have the following installed:

- **Docker** and **Docker Compose**
- **Ballerina Swan Lake (latest version)**
- **MongoDB**
- **Kafka**

---


## Microservices

### Passenger Service (Port: 8081)

**Purpose:** Handles user registration, authentication, and profile management.

**Key Features:**
- User registration and login  
- Profile management  
- View purchased tickets  

**API Endpoints:**
| Method | Endpoint | Description |
|--------|-----------|-------------|
| `POST` | `/passenger/register` | Register a new passenger |
| `POST` | `/passenger/login` | Authenticate a passenger |
| `GET`  | `/passenger/profile/{userId}` | Get passenger profile |
| `PUT`  | `/passenger/profile/{userId}` | Update passenger profile |
| `GET`  | `/passenger/tickets/{userId}` | Get passenger tickets |

---

### Transport Service (Port: 9002)

**Purpose:** Manages transportation routes, trips, and schedules.

**Key Features:**
- Create and manage routes  
- Schedule trips  
- Track available seats  

**API Endpoints:**
| Method | Endpoint | Description |
|--------|-----------|-------------|
| `POST` | `/transport/routes` | Create a new route |
| `GET`  | `/transport/routes` | Get all routes |
| `GET`  | `/transport/routes/{routeId}` | Get route details |
| `POST` | `/transport/trips` | Create a new trip |
| `GET`  | `/transport/trips` | Get all trips |
| `GET`  | `/transport/trips/route/{routeId}` | Get trips for a specific route |

---

### Ticketing Service

**Purpose:** Handles ticket creation, purchase, and validation.

**Key Features:**
- Create tickets for trips  
- Validate tickets  
- Track ticket status  

---

### Payment Service

**Purpose:** Processes payments for ticket purchases.

**Key Features:**
- Process payments  
- Manage refunds  
- View payment history  

---

### Notification Service

**Purpose:** Sends notifications to users about system events.

**Key Features:**
- Trip reminders  
- Ticket purchase confirmations  
- Service disruption alerts  

---

### Admin Service

**Purpose:** Provides administrative capabilities for managing the entire system.

**Key Features:**
- Manage users  
- Monitor system status  
- Configure global settings  

---

## Data Storage

- **MongoDB** → Persistent storage for passengers, tickets, routes, and trips  
- **Kafka** → Event-driven communication between microservices  

---

## Docker Deployment

Each microservice includes its own `Dockerfile`.  
The **`docker-compose.yml`** file orchestrates all services and dependencies.

Example:
```bash
docker-compose up -d
```

---

## Development

### Project Structure
```
public-transport-system/
├── admin-service/
├── notification-service/
├── passenger-service/
├── payment-service/
├── ticketing-service/
├── transport-service/
└── docker-compose.yml
```

## Testing

Each microservice can be tested independently using **Ballerina’s built-in testing framework**:
```bash
bal test
```

---


