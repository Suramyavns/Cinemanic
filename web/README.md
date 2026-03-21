# Cinemanic Web - Next.js Application

Cinemanic Web is the comprehensive web interface and backend API for the Cinemanic application suite. Built with [Next.js](https://nextjs.org), it leverages [Drizzle ORM](https://orm.drizzle.team) for database access and [Firebase](https://firebase.google.com) for authentication.

## 🚀 Getting Started

Follow these steps to set up the web application locally.

### Prerequisites

- Node.js (v18.0.0 or higher)
- npm, yarn, or pnpm
- A Postgres database (e.g., [Prisma](https://prisma.io))
- A [Firebase Project](https://console.firebase.google.com)
- A [TMDb API Key](https://www.themoviedb.org/documentation/api)

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/Suramyavns/Cinemanic.git
    cd cinemanic/web
    ```

2.  **Install dependencies:**
    ```bash
    npm install
    ```

3.  **Environment Setup:**
    Create a `.env` file in the `web` root directory and add the following keys. Refer to `.env.example` if available.
    ```env
    # Firebase Service Account
    FIREBASE_PROJECT_ID=your_firebase_project_id
    FIREBASE_CLIENT_EMAIL=your_firebase_client_email
    FIREBASE_PRIVATE_KEY="your_firebase_private_key"

    # Firebase Client (Public)
    NEXT_PUBLIC_FIREBASE_API_KEY=your_firebase_api_key
    NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=your_firebase_auth_domain
    NEXT_PUBLIC_FIREBASE_PROJECT_ID=your_firebase_project_id
    NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=your_firebase_storage_bucket
    NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=your_firebase_messaging_sender_id
    NEXT_PUBLIC_FIREBASE_APP_ID=your_firebase_app_id

    # TMDb API
    TMDB_API_KEY=your_tmdb_api_key
    TMDB_BASE_URL=https://api.themoviedb.org

    # Database
    DATABASE_URL="your_database_connection_url"

    # API Configuration
    CORS_ORIGIN=*
    NEXT_PUBLIC_PLAYER_URL=https://vidlink.pro
    ```

4.  **Database Migration (if applicable):**
    ```bash
    npx drizzle-kit push
    ```

5.  **Run the development server:**
    ```bash
    npm run dev
    ```

### Open the Application

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

## 🛠️ Key Environment Variables

| Variable | Description | Source |
| :--- | :--- | :--- |
| `DATABASE_URL` | Connection string for Postgres | Database Provider |
| `FIREBASE_PRIVATE_KEY` | Private key for Firebase Admin SDK | Firebase Console |
| `TMDB_API_KEY` | API key for movie data | TMDb Account |
| `NEXT_PUBLIC_PLAYER_URL` | Base URL for the video player | External Player Provider |

## 📦 Features & Tech Stack

- **[Next.js](https://nextjs.org)**: Using the App Router for optimized routing and server-side rendering.
- **[Drizzle ORM](https://orm.drizzle.team)**: Type-safe database interactions.
- **[Firebase Authentication](https://firebase.google.com/docs/auth)**: Secure server-side session management.
- **[TMDb Integration](https://developer.themoviedb.org/docs/getting-started)**: Real-time movie and TV show data.
- **[Tailwind CSS](https://tailwindcss.com)** (if applicable): Modern styling and responsive layout.

## 🛠️ Project Structure

- `src/app/`: Next.js App Router pages and API routes.
- `src/db/`: Drizzle schema and database configuration.
- `src/lib/`: Reusable utility functions and API clients.
- `public/`: Static assets such as images and icons.
- `drizzle/`: Database migrations.

