# SiDiff/SiLift Dev-Container

This creates a Docker container with a desktop to lauch an Eclipse workspace for SiDiff/SiLift.
The related repositories for this project can be found at:

- [sidiff-common](https://github.com/manuelohrndorf/sidiff-common)
- [sidiff-matching](https://github.com/manuelohrndorf/sidiff-matching)
- [sidiff-lifting](https://github.com/manuelohrndorf/sidiff-lifting)

To setup the Dev-Container:

1. Install [Docker (Desktop) (including Docker Compose)](https://docs.docker.com/get-started/get-docker/)
1. Initially, clone this repository:
    ```
    git clone --branch main https://github.com/manuelohrndorf/sidiff-dev-container.git
    cd sidiff-dev-container
    ```
1. Build the image. You only have to repeat this for updates of the image:
    ```
    docker compose build --no-cache
    ```
1. Start the container:
    ```
    docker compose up
    ```
1. Open the development desktop in your browser:
   - [http://localhost:3000/](http://localhost:3000/)
1. Start `Eclipse SiDiff` from the desktop icon.
1. Initially, **clean build** the project. From the Eclipse menu: `Project > Clean... > [x] Clean all projects > Clean`
1. From the toolbar select: `Run > Eclipse-SiDiff`.
1. This opens a second runtime Eclipse instance with the SiDiff/SiLift plugins loaded...
1. To stop the container - this keeps only changes wrt. to the home folder in the corresponding Docker volume, i.e., repositories and the workspace.:
    ```
    docker compose down
    ```
1. To entirely remove the Docker volume with the home directory:
    ```
    docker volume rm sidiff-dev-container_dev_container_data_sidiff 
    ```
1. To also remove the image:
    ```
    docker image rm sidiff-dev-container-dev-container-sidiff
    ```