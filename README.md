# HOW TO RUN

- Build the docker image by running `docker build -t nstk-api .`
- Run Docker container by running `docker run -p 3000:3000 -v ${PWD}:/app --name nstk-api nstk-api  `