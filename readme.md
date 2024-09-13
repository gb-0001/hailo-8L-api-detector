# Security Camera - Detection System on Raspberry Pi 5 with Frigate and Hailo 8L

This procedure outlines the steps to set up a person detection system on a Raspberry Pi 5, using Frigate and a Hailo 8L detector.



## 1. Overview of CPU Usage on RPI5

- **85% CPU Usage**: 5 RTSP cameras with a video source of 1920x1080 at 30fps, using the yolov6n.hef model (640x640) with a batch size of 8.
- **19% CPU Usage**: 2 RTSP cameras with a video source of 1920x1080 at 30fps, using the same yolov6n.hef model with a batch size of 8.

## 2. Hailo-8L Container Logs

Example output from the detector logs :
```plaintext
2024-09-02 14:41:25.403 [web_log.py:211] INFO:172.20.0.2 [02/Sep/2024:13:41:25 +0100] "POST /v1/vision/detection HTTP/1.1" 200 675 "-" "python-requests/2.32.3"
2024-09-02 14:41:25.490 [web_server.py:202] INFO:Request ID: 025a5949-dbdd-49d0-b587-de37a20c93d3; Found person; roundtrip, ms: 27; inference, ms: 14
2024-09-02 14:41:25.491 [web_log.py:211] INFO:172.20.0.2 [02/Sep/2024:13:41:25 +0100] "POST /v1/vision/detection HTTP/1.1" 200 675 "-" "python-requests/2.32.3"
2024-09-02 14:41:25.611 [web_server.py:202] INFO:Request ID: 5ad0d13f-c143-4780-a216-502f327c491a; Found person; roundtrip, ms: 28; inference, ms: 14
```

## 3. Project Merging

To implement a Deepstack API equivalent for Frigate on a Raspberry Pi 5, I merged the following two projects:

- **Project 1** : Hailo Object Detection Mini Server - [Source](https://github.com/serg987/hailo-mini-od-server)
- **Project 2** : pi-ai-kit-ubuntu for preparing the RPI5 host - [Source](https://github.com/canonical/pi-ai-kit-ubuntu)

For more details, refer to the respective README files :
- [README_pi-ai-kit-ubuntu.md](https://github.com/gb-0001/hailo-8L-api-detector/blob/master/README_pi-ai-kit-ubuntu.md)

## 4. RPI Requirement

### 4.1 OS Installation

1. Install `Bookworm 12.6 (OS 64)` on your Raspberry Pi 5.
   - [Raspberry Pi Documentation](https://www.raspberrypi.com/documentation/accessories/ai-kit.html)
   - [Detailed Guide on GitHub](https://github.com/gb-0001/hailo-8L-api-detector/blob/master/doc/about.adoc)

### 4.2 Hailo 8L Installation

1. Follow the instructions provided in the link below to install Hailo 8L :
   - [Hailo Documentation](https://community.hailo.ai/t/hailo-8l-on-ubuntu-24-04-using-docker/1771)

## 5. Configuration and Deployment

### 5.1 RPI5 Preparation

1. Preparation :
   - ```bash
     #install du rpi 64bit
        sudo apt update
        sudo apt upgrade -y
        
        #Set GPU memory to at least 128Mo, preferably  256Mo
        sudo raspi-config
        ==> 4 Performance Options 
        ==> P2 GPU Memory
        ==> 128  ou 256
        
        #For Frigate configuration and video storage
        mkdir ~/frigate-nvr
        mkdir ~/frigate-nvr/storage
     ```

2. Install docker + portainer :
   - ```bash
     #install docker
        curl -sSL https://get.docker.com | sh
        sudo usermod -aG docker $USER
        logout
        reboot
        groups
        #test hello-world
        docker run hello-world

     #install portainer
        sudo docker pull portainer/portainer-ce:latest
        sudo docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
     ```

     #Access URL:

     http://[RPI5-IPADDRESS]:9000


### 5.2 Launching the Frigate Container

1. Launch the container using Docker-compose :

   - #CONFIGURATION Frigate container docker-compose.yml ==> [frigate-nvr/docker-compose.yml] (https://github.com/gb-0001/hailo-8L-api-detector/blob/master/frigate-nvr/docker-compose.yml)

   - Modify the path ~/frigate-nvr dans docker-compose.yml:

       volumes:

         - /etc/localtime:/etc/localtime:ro

         - ~/frigate-nvr/config.yml:/config/config.yml

         - ~/frigate-nvr/storage:/media/frigate

    - Update  "MYPASSWORD" for CAM1 and CAM2 passwords in docker-compose.yml:

      environment:

        FRIGATE_RTSP_PASSWORD: "MYPASSWORD" # RTSP CAM1 PASSWORD

        FRIGATE_RTSP_PASSWORD2: "MYPASSWORD" # RTSP CAM2 PASSWORD


   - #CONFIGURATION FRIGATE config.yml ==> [frigate-nvr/config/config.yml] (https://github.com/gb-0001/hailo-8L-api-detector/blob/master/frigate-nvr/config/config.yml)

     Modify  [RPI5-IPADDRESS] +  [USERCAM] + [IPCAM1] + PORT ==> :554/live/ch0:

       detectors:

         deepstack:

            api_url: http://[RPI5-IPADDRESS]:8080/v1/vision/detection

        cameras:

          CAM1: #Name for your comment

            ffmpeg:

            inputs:

                - path: rtsp://[USERCAM]:{FRIGATE_RTSP_PASSWORD}@[IPCAM1]:554/live/ch0
            ...


    # Launch the Frigate container:

   - ```bash
     docker compose up -d frigate
     ```
     #Access URL :

     http://[RPI5-IPADDRESS]:5008



### 5.3 Installing the Hailo-8L-api-detector Container

1. Launch the container using Docker-compose :

   - /!\ Warning Possible but unimportant for        - DISPLAY=${DISPLAY}

   - ```bash
     git clone https://github.com/gb-0001/hailo-8L-api-detector.git

     cd hailo-8L-api-detector

     docker compose up -d hailo-8l-api-detector
     ```

     #Access URL HAILO_8L api_url:
    
     http://[RPI5-IPADDRESS]:8080/v1/vision/detection


2. Check the logs to ensure everything is functioning correctly :
   - ```bash
      docker logs hailo-8L-api-detector
     ```

## 6. References

- [Hailo Mini Object Detection Server](https://github.com/serg987/hailo-mini-od-server)
- [pi-ai-kit-ubuntu](https://github.com/canonical/pi-ai-kit-ubuntu)
- [Hailo Community Documentation](https://community.hailo.ai/t/hailo-8l-on-ubuntu-24-04-using-docker/1771)




