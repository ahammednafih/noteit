# Noteit

Noteit is a secure, modern collaborative note-taking application built on Ruby on Rails 8.

## Technology Stack

- **Framework**: Ruby on Rails 8.x
- **Runtime Manager**: [Mise](https://mise.jdx.dev/) (defined in `mise.toml`)
  - **Ruby**: 4.0.4
  - **Node.js**: 20.9.0
- **Database**: PostgreSQL (split into `primary` and `queue` databases)
- **Background Jobs**: [Solid Queue](https://github.com/rails/solid_queue) (native DB-backed queue adapter)
- **Search**: [PgSearch](https://github.com/Casecommons/pg_search) (PostgreSQL full-text search)
- **Rich Text Editor**: [Lexxy Editor](https://github.com/basecamp/lexxy) (Modern 37signals web component-based editor)
- **Frontend / Styling**: Bootstrap 4 layout styled with Custom CSS & Tailwind CSS v4, Stimulus, and Turbo.

---

## Setup Instructions

### 1. Prerequisites

Make sure you have [Mise](https://mise.jdx.dev/) and PostgreSQL installed on your system. 

```bash
# Trust the project's mise configuration
mise trust
```

### 2. Installation and Initial Setup

Run the setup script to install dependencies, create databases, migrate schemas, and seed initial records:

```bash
bin/setup
```

*(Note: `bin/setup` will prepare your database and assets but will not start the development server.)*

### 3. Seed Credentials

The initial seed data sets up the following test accounts:

- **John Doe (Demo User)**:
  - **Email**: `demo@example.com`
  - **Password**: `password`
- **Jane Smith**:
  - **Email**: `jane@example.com`
  - **Password**: `password123`

---

## Running the Application

To run the development server, esbuild compiler, Tailwind CSS compiler, and the Solid Queue background worker concurrently:

```bash
bin/dev
```

This will boot the application (default port is `3000`). If you wish to run it on a specific port (e.g. `3003`):

```bash
bin/dev -p 3003
```

---

## Running the Test Suite

Run the Minitest test suite (including controller, model, integration, and system tests) using:

```bash
bin/rails test
```

---

## Key Commands & Workflows

### Background Job Worker
Solid Queue background jobs are run via the Procfile.dev configuration using:
```bash
bin/jobs
```

### Full-Text Search
PgSearch indexes note titles and content with prefix matching. To trigger a search in notes, utilize the search forms available on the public notes lists.
