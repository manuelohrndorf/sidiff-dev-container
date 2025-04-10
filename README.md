# SiDiff/SiLift Dev-Container

1. Install [Docker (Desktop) (including Docker Compose)](https://docs.docker.com/get-started/get-docker/)
1. Initially, clone this repository:
    ```
    git clone https://github.com/manuelohrndorf/sidiff-dev-container.git
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
1. Initially, select from the Eclipse menu: `Project > Clean... > [x] Clean all projects > Clean`
1. From the toolbar select: `Run > Eclipse-SiDiff`.
1. This opens a second Eclipse instance with the SiDiff/SiLift plugins loaded...