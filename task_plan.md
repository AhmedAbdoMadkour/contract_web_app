# Sasheco Contract Project - Execution Roadmap & Task Plan

This document outlines the detailed execution roadmap and task breakdown for the Sasheco Contract Project, based on the approved implementation plan. It is structured to allow specialist agents (.NET Expert, Flutter Expert, UI/UX Expert) to work in parallel where possible.

---

## 🏗️ Architecture & Domain Overview

**Backend**: .NET Core Web API, Clean Architecture, Entity Framework Core, SQL Server.
**Frontend**: Flutter (Mobile/Web), Provider/Riverpod state management.
**Storage**: Local storage (Dev) -> Azure Blob Storage (Prod).

---

## 🔌 API Contracts (REST)

Define these explicitly to unblock Frontend development.

### 1. Auth & Users
- `POST /api/auth/login` | Body: `{email, password}` | Response: `{token, user}`
- `GET /api/users` | Response: `List<User>` (Used for List/Kanban Views)
- `POST /api/users` | Body: `{name, email, password, position, photoUrl, permissions}`
- `PUT /api/users/{id}/permissions` | Body: `{permissions: string[]}`

### 2. Vendors & Sites
- `GET /api/vendors` | Response: `List<Vendor>` (Used for List/Kanban Views)
- `POST /api/vendors` | Body: `{contractorName, authorizedRepresentative, phoneNumber, commercialRegisterNumber, taxCardNumber}`
- `GET /api/sites` | Response: `List<Site>` (Includes `TotalContracts` field)
- `POST /api/sites` | Body: `{projectName}`

### 3. Templates & Documents
- `GET /api/templates` | Response: `List<ContractTemplate>`
- `POST /api/templates` | Body: `{name, defaultPreamble, defaultLegalCondition, defaultClauses}`

### 4. Contracts Workflow
- `GET /api/contracts` | Query: `?status=x` | Response: `List<Contract>` (Used for List/Kanban Views)
- `POST /api/contracts/engineering` (Stage 1) | Body: `{projectSiteId, vendorId, items, quantities, drawings[], paymentTerms}` | Response: `{contractId}`
- `PUT /api/contracts/{id}/secretary` (Stage 2) | Body: `{templateId, preamble, legalCondition, contractClauses}`
- `PUT /api/contracts/{id}/financial` (Stage 3) | Body: `{reviewNotes, confirmed: boolean}`
- `POST /api/contracts/{id}/approve` (Stage 4) | Body: `{approved: boolean, comments}`

---

## 🛤️ Execution Phases & Task Breakdown

### Phase 1: Setup & Backend Foundations
**Assigned to**: .NET Expert
**Goal**: Establish the base solution and CRUD APIs.

- [ ] **Task 1.1**: Initialize .NET Core Web API using Clean Architecture. Set up Solution folders (Core, Infrastructure, Application, API).
- [ ] **Task 1.2**: Define Domain Entities (User, Permission, Vendor, ProjectSite, ContractTemplate, Document).
- [ ] **Task 1.3**: Configure Entity Framework Core with SQL Server. Write initial migrations.
- [ ] **Task 1.4**: Implement JWT Authentication & Auth endpoints (`POST /api/auth/login`).
- [ ] **Task 1.5**: Implement User Management APIs (`GET /api/users`, `POST /api/users`, `PUT /api/users/{id}/permissions`).
- [ ] **Task 1.6**: Implement Vendor & ProjectSite APIs (`GET /api/vendors`, `POST /api/vendors`, `GET /api/sites`, `POST /api/sites`). Ensure `TotalContracts` calculation on `GET /api/sites`.
- [ ] **Task 1.7**: Implement Contract Template APIs (`GET /api/templates`, `POST /api/templates`).

---

### Phase 2: Frontend Foundation & UI/UX Design
**Assigned to**: Flutter Expert & UI/UX Expert
**Goal**: Set up the app structure, navigation, and core reusable UI components.
*Note: Can start concurrently with Phase 1.*

- [ ] **Task 2.1**: Initialize Flutter Project. Configure routing (e.g., go_router) and state management (e.g., Riverpod).
- [ ] **Task 2.2**: Define core theme, typography, and color palette based on Sasheco branding.
- [ ] **Task 2.3**: Build layout shell (Sidebar/Appbar for Web/Mobile).
- [ ] **Task 2.4**: Create Reusable `ListView` component (DataTable with sorting/pagination).
- [ ] **Task 2.5**: Create Reusable `KanbanView` component (Drag-and-drop columns based on status).
- [ ] **Task 2.6**: Implement Auth UI (Login Screen) and wire it to state.
- [ ] **Task 2.7**: Implement Users, Vendors, and Sites screens using the reusable ListView and KanbanView widgets (mock data if Phase 1 APIs are not ready).

---

### Phase 3: Core Domain APIs (Contracts Workflow)
**Assigned to**: .NET Expert
**Goal**: Implement the 4-stage contract approval workflow engine.
*Prerequisites: Phase 1 complete.*

- [ ] **Task 3.1**: Define Contract and ContractHistory domain entities (Include 4 stages of data: Engineering, Secretary, Financial, Approval).
- [ ] **Task 3.2**: Implement `GET /api/contracts` API (Support filtering by status for Kanban/List views).
- [ ] **Task 3.3**: Implement Stage 1 API: `POST /api/contracts/engineering` (Initial contract creation with Engineering data).
- [ ] **Task 3.4**: Implement Stage 2 API: `PUT /api/contracts/{id}/secretary` (Update contract with Template, Preamble, Clauses).
- [ ] **Task 3.5**: Implement Stage 3 API: `PUT /api/contracts/{id}/financial` (Financial review and notes).
- [ ] **Task 3.6**: Implement Stage 4 API: `POST /api/contracts/{id}/approve` (Final approval/rejection logic).
- [ ] **Task 3.7**: Ensure `ContractHistory` is appended automatically on every state change.

---

### Phase 4: Frontend Contract Workflows
**Assigned to**: Flutter Expert
**Goal**: Build the complex multi-step forms and integrate with Phase 3 APIs.
*Prerequisites: Phase 2 complete. Phase 3 APIs ready (or mocked).*

- [ ] **Task 4.1**: Implement Contracts Dashboard (using `ListView` and `KanbanView` wired to `GET /api/contracts`).
- [ ] **Task 4.2**: Implement Stage 1 Form (Engineering). Select Site, Vendor, input BOQ, drawings, payment terms.
- [ ] **Task 4.3**: Implement Stage 2 Form (Secretary). 
    - Fetch selected Vendor details.
    - Dropdown to select a `ContractTemplate`.
    - Dynamic text areas for Preamble, Legal Condition, and Clauses (pre-filled from Template).
    - Read-only view of Engineering inputs (BOQ, Payment terms).
- [ ] **Task 4.4**: Implement Stage 3 Form (Financial). Read-only view of previous stages + Input for Financial Review Notes.
- [ ] **Task 4.5**: Implement Stage 4 Form (Approval). Read-only view of the entire contract + Approve/Reject actions.
- [ ] **Task 4.6**: Document Generation View (Generate PDF/Print layout of the finalized contract).

---

## 🔄 Cross-Platform & Risk Considerations
- **Responsive Forms**: The Secretary document builder form (Stage 2) contains a lot of text. Ensure it has a robust layout on Web (Desktop) while remaining accessible on Mobile/Tablets.
- **File Uploads**: Engineering drawings will require file upload handling. Ensure API supports `multipart/form-data` and Flutter web supports file picking smoothly.
- **Kanban on Mobile**: Kanban boards can be tricky on narrow screens. Consider a fallback horizontal scroll or stacked view on Mobile, keeping the traditional Kanban for Web/Desktop.
