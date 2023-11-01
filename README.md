# HOW TO RUN

- Build the docker image by running `docker build -t nstk-api .`
- Run Docker container by running `docker run -p 3000:3000 -v ${PWD}:/app --name nstk-api nstk-api  `
- if getting `A server is already running. Check /app/tmp/pids/server.pid.` error, run `docker exec -it nstk-api rm /app/tmp/pids/server.pid` after running the container.