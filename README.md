# Dart Server Starter  ( Hobby Project )

## Features:
- Permission based JWT Authentication
- Postgres SQL Setup
- Extension of Request Class
- Abstract WebController

## Running Application

1. Install docker, docker-compose
2. Clone this repository and cd to project folder
3. From project folder build image ```docker build -t dartserverstarter .```
3. Run ```docker-compose up``` 
4. Go to 127.0.0.1:8080, Adminer should open
5. Login to adminer. Use credentials from config.dart or from docker-compose.yml. If you change the credentials be sure to change at both places
6. Import the migration from lib/migration/ folder.
7. Go to 127.0.0.1:8000 , If you see 404 not found then Congratulations!



