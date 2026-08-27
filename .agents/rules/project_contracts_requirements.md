---
trigger: always_on
description: Core functional requirements and business logic for the Sasheco Contract Project
---

# Sasheco Contract Project Requirements

This rule provides the core business logic and requirements for the Sasheco Contract Project. All agents (Backend, Frontend, UI/UX, Project Manager) MUST adhere to these requirements when making technical decisions or writing code.

## 1. Domain Models & Entities
- **User:** Name, Email, Password, Position, Photo, and granular Permissions.
- **Vendor (Contractor):** Contractor Name, Authorized Representative, Phone, Commercial Register Number, Tax Card Number.
- **Project Site:** Project Name, and a calculated field for the total number of contracts on the site.
- **Contract Template:** Title, Type, Default Preamble, Default Legal Condition, and Default Clauses.
- **Contract:** Follows a strict 4-stage workflow. Contains First Party (Sasheco) and Second Party (Vendor) details.

## 2. Contract Workflow (The 4 Stages)
1. **Engineering (Stage 1):** Engineers input the BOQ (Bill of Quantities) items manually or via Excel upload (Columns: Item Code, Item Name, Quantity, Item Price). The total per item is automatically calculated. They also upload drawings and specify payment terms. Finally, they can "Save" the data or explicitly "Submit Contract" to lock Stage 1 and advance the contract to Stage 2.
2. **Secretary (Stage 2):** The secretary selects a Contract Template, links the Engineering data (BOQ, payment terms) to it, and finalizes the Preamble, Legal Conditions, and Clauses.
3. **Financial (Stage 3):** The financial department reviews the complete contract.
4. **Approval (Stage 4):** High-level management gives final approval.

## 3. UI/UX Requirements
- All major entities (Contracts, Users, Vendors, Projects) MUST have both a **List View** and a **Kanban View**.
- The Secretary screen must dynamically merge Template text with Engineering data.

## 4. Tech Stack & Architecture
- **Backend:** .NET Core Web API, Clean Architecture, EF Core, SQL Server.
- **Frontend:** Flutter (Mobile/Web) using Riverpod/Provider.
- **Storage:** Local storage for development, Azure Blob Storage for production.
