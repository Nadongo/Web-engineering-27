# Nairobi Reads
Community Book Exchange Application built with Ruby on Rails.

## Application Overview
Nairobi Reads is a localized digital noticeboard designed to help community members share, lend, and borrow books completely free of charge.

The application solves the problem of expensive book purchases and unused personal libraries by providing a transparent, trust-based platform that connects readers and fosters a local reading culture. Key features include:

* A public catalog of books available for borrowing.
* A trust-based borrowing system (no payment gateways).
* Public user profiles highlighting community trust scores and preferred meeting spots (e.g., "Java House, Yaya Centre").
* "My Bookshelf" for users to manage their uploaded books and track items they have lent out.
* Issue reporting and return tracking.
* Administrator management screen.


## Development Environment
* **Ruby:** 3.0.1
* **Ruby on Rails:** 6.1.7.6
* **Database:** PostgreSQL
* **Testing:** RSpec
* **Authentication:** BCrypt

## Application Setup Procedure
Follow the steps below to run the application locally.

**1. Clone the Repository**
```bash
git clone https://github.com/Nadongo/Web-engineering-27.git
cd Web-engineering-27
```
**2. Install Dependencies**
``` bash
bundle install
```
**3. Setup Database and Seed Initial Data**
``` bash
rails db:create
rails db:migrate
rails db:seed
```
**4. Start the Server**
``` bash
rails s
```
Access the application in your browser:

http://localhost:3000/

## Requirement Definition Materials
**CheckSheet**

https://docs.google.com/spreadsheets/d/1WR8DDF1UHumFsNLEIzvfCpT_e-v11_rg/edit?usp=sharing&ouid=116281988887373864705&rtpof=true&sd=true

**Catalog Design**

https://docs.google.com/spreadsheets/d/1WR8DDF1UHumFsNLEIzvfCpT_e-v11_rg/edit?usp=sharing&ouid=116281988887373864705&rtpof=true&sd=true

**Table Definition**

https://docs.google.com/spreadsheets/d/1WR8DDF1UHumFsNLEIzvfCpT_e-v11_rg/edit?usp=sharing&ouid=116281988887373864705&rtpof=true&sd=true

**WireFrame**

https://cacoo.com/diagrams/1eCsGXQAUFUT8OuC/B657D 

## ER Diagram
Below is the ER diagram representing the relationships between tables.

[Entity Diagram]

<img width="823" height="739" alt="Screenshot 2026-04-17 143637" src="https://github.com/user-attachments/assets/56401d02-2b01-4904-a05f-853cf10e16c3" />

# Screen Transition Diagram
Below is the screen transition diagram representing the application flow.

[Screen Transition]

<img width="1151" height="766" alt="Screenshot 2026-04-17 143620" src="https://github.com/user-attachments/assets/631b46bc-47fc-497f-ad24-25160f023df5" />


## Application Features
# 1. User Authentication
* Sign up, Login, and Logout
* Guest Login (One-click access for general users)
* Guest Admin Login (One-click access for evaluation)

# 2. Book Management (My Bookshelf)
* Upload a new book to the catalog.
* Edit book details (Title, Author, Category, Description).
* Delete/Remove a book from the catalog.
* Mark a lent book as "Returned".
  
# 3. Community Borrowing System
* Browse the public catalog.
* Click "Request to Borrow" on available books.
* Public User Profiles displaying "Preferred Meeting Spot" and borrow history.
* "Report Issue" functionality for unreturned books.
  
# 4. Category Management
* Filter books by category/genre.

# 5. Administrator Screen
* Secure Admin Dashboard (rails_admin first screen only)
* User and Role Management
* Catalog and Category Management

## Notes
* The administrator screen is implemented using the rails_admin gem and is strictly protected from general user access.
* As required by the assignment, only the first admin screen is described in the screen transition diagram.
* All high-priority functions, including basic CRUD operations and authentication, are tested using RSpec (Model and System Specs).

