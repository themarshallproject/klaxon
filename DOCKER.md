# Running Klaxon with Docker

## Development Quickstart

0.  Preparation

    1. Copy the `.env.sample` to `.env` in this project and update the environment variables accordingly. See the `.env.sample` file for additional information.
    2. Use [`mkcert`](https://github.com/FiloSottile/mkcert) to generate SSL certificates for local development. Having local https allows you to run Klaxon closer to how you'd run it in production.

       1. If on macOS, you can use Homebrew. If on a different platform, see the directions in the `mkcert` repository.

       ```bash
       brew install mkcert
       brew install nss # if you use Firefox

       mkcert localhost
       mkcert -install
       ```

       2. Copy the generated files to `localhost.crt` (the public key) and `localhost.key` (the private key) into the `certs/` directory in this repository.

1.  Now you're ready to start Klaxon locally! Run the following commands:

```
docker-compose up --build
open https://localhost:4443
```

2. Enter `admin@news.org` in the email window. It should redirect you to a page that says: "Email Sent".

3. In the console find where it says "Go to Dashboard ( ... )" and copy and paste the link into the browser.

4. You'll now be logged in. The page should say "Watch Your First Item".
