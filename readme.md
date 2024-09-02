FRIGATE CONTAINER + HAILO 8L DETECTOR CONTAINER ON RPI 5 

#CPU USED on RPI5

85% ==> 5 CAMERA RTSP video source 1920x1080 30fps detector frigate 640x640 model yolov6n.hef batch size 8 (config.py==>class Config)
19% ==> 2 CAMERA RTSP video source 1920x1080 30fps detector frigate 640x640 model yolov6n.hef batch size 8 (config.py==>class Config)

Log container hailo-8L-api-detector:
2024-09-02 14:41:25.403 [web_log.py:211] INFO:172.20.0.2 [02/Sep/2024:13:41:25 +0100] "POST /v1/vision/detection HTTP/1.1" 200 675 "-" "python-requests/2.32.3"
2024-09-02 14:41:25.490 [web_server.py:202] INFO:Request ID: 025a5949-dbdd-49d0-b587-de37a20c93d3; Found person; roundtrip, ms: 27; inference, ms: 14
2024-09-02 14:41:25.491 [web_log.py:211] INFO:172.20.0.2 [02/Sep/2024:13:41:25 +0100] "POST /v1/vision/detection HTTP/1.1" 200 675 "-" "python-requests/2.32.3"
2024-09-02 14:41:25.611 [web_server.py:202] INFO:Request ID: 5ad0d13f-c143-4780-a216-502f327c491a; Found person; roundtrip, ms: 28; inference, ms: 14



Fusion des 2 projets ci-dessous pour faire fonctionner sur RPI 5 (Raspberry Pi 5) un equivalent deepstack api pour frigate:

Le container hailo-8L-api-detector permet sur RPI 5 de faire de la detection de personne avec Object Detection Coco
README_pi-ai-kit-ubuntu.md

Fusion des dockerfile et compose  de Hailo object detection mini server + [pi-ai-kit-ubuntu pour et préparation host RPI5]
source 1 (https://github.com/serg987/hailo-mini-od-server) + source 2 (https://github.com/canonical/pi-ai-kit-ubuntu) https://github.com/gb-0001/hailo-8L-api-detector/blob/master/README_pi-ai-kit-ubuntu.md

https://community.hailo.ai/t/hailo-8l-on-ubuntu-24-04-using-docker/1771


#Prérequis sur RPI5:
- OS 64 Installation de bookworm 12.6 ===> https://www.raspberrypi.com/documentation/accessories/ai-kit.html || https://github.com/gb-0001/hailo-8L-api-detector/blob/master/doc/about.adoc
- installation de Hailo 8L ===> https://www.raspberrypi.com/documentation/accessories/ai-kit.html || https://github.com/gb-0001/hailo-8L-api-detector/blob/master/doc/getting-started.adoc

#Installation docker + portainer
- installation de docker 
    #Install frigate-nvr Docker
    
    source des commandes ci-dessous Install frigate-nvr Docker
    https://pimylifeup.com/raspberry-pi-frigate-nvr/
    
        #install du rpi 64bit
        sudo apt update
        sudo apt upgrade -y
        
        #passer le GPU en 128Mo mini mieux 256Mo
        sudo raspi-config
        ==> 4 Performance Options 
        ==> P2 GPU Memory
        ==> 128  ou 256
        
        mkdir ~/frigate-nvr
        mkdir ~/frigate-nvr/storage
        
        #install docker
        curl -sSL https://get.docker.com | sh
        sudo usermod -aG docker $USER
        logout
        reboot
        groups
        #test de fonctionnement hello-world
        docker run hello-world
        
        
        #install portainer
        sudo docker pull portainer/portainer-ce:latest
        sudo docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
        
        http://[PIIPADDRESS]:9000

#creation du container frigate
  FRIGATE SETTING :
      nano ~/frigate-nvr/config.yml
    
      mqtt:
        enabled: True
        host: 192.168.1.XXX  # Utilisez 'core-mosquitto' comme hote ip Home Assistant
        port: 1883  # Port par dÃ©faut pour MQTT
        topic_prefix: frigate  # PrÃ©fixe de sujet
        client_id: frigate  # ID du client
        user: mqttuser  # Nom d'utilisateur pour se connecter au serveur MQTT
        password: mqttpassword  # Mot de passe pour se connecter au serveur MQTT
        stats_interval: 60  # Intervalle en secondes pour publier les statistiques
      
      ffmpeg:
        hwaccel_args: preset-rpi-64-h264 #Enable Hardware Acceleration
      
      detectors:
        deepstack:
          api_url: http://MYIP:8080/v1/vision/detection
          type: deepstack
          api_timeout: 5
      
      record:
        enabled: True
        retain:
          days: 7
          mode: motion
        events:
          retain:
            default: 30
            mode: motion
      
      snapshots:
        enabled: True
        retain:
          default: 5
      
      cameras:
        CAM1: #Name for your comment
          ffmpeg:
            inputs:
              - path: rtsp://MYUSERCAM1:{FRIGATE_RTSP_PASSWORD}@192.168.1.XXX:554/live/ch0 #The Stream you want to monitor
                roles:
                  - record
              - path: rtsp://MYUSERCAM1:{FRIGATE_RTSP_PASSWORD}@192.168.1.XXX:554/live/ch1 #The Stream you want to monitor
                roles:
                  - detect
          detect:
            enabled: True # Detection is disabled
            width: 640 # The Cameras resolution
            height: 640 # The Cameras resolution
            fps: 5
        
    CAM2:
      ffmpeg:
        inputs:
          - path: rtsp://MYUSERCAM2:{FRIGATE_RTSP_PASSWORD2}@192.168.1.XXX:554/live/ch00_0 #The Stream you want to monitor
            roles:
              - detect
              - record
      detect:
        enabled: True # Detection is disabled
        width: 640 # The Cameras resolution
        height: 640 # The Cameras resolution
        fps: 5
      #onvif:
      #  host: 192.168.1.XXX
      #  port: 8000
      #  user: MYUSERCAM2
      #  password: {FRIGATE_RTSP_PASSWORD2}
      version: 0.14


      nano ~/frigate-nvr/docker-compose.yml
      services:
          frigate:
            container_name: frigate
            privileged: true # this may not be necessary for all setups
            restart: unless-stopped
            image: ghcr.io/blakeblackshear/frigate:stable
            shm_size: "256mb"
            devices:
              - /dev/bus/usb:/dev/bus/usb #Used for Coral if Available
              - /dev/hailo0
            volumes:
              - /etc/localtime:/etc/localtime:ro
              - /projects/frigate-nvr/config.yml:/config/config.yml
              - /projects/frigate-nvr/storage:/media/frigate
              - type: tmpfs #Remove this if using a Pi with 2GB or Less RAM
                target: /tmp/cache
                tmpfs:
                  size: 1000000000
            ports:
              - "5008:5000"
              - "8554:8554" # RTSP feeds
              - "8555:8555/tcp" # WebRTC over tcp
              - "8555:8555/udp" # WebRTC over udp
            environment:
              FRIGATE_RTSP_PASSWORD: "MYPASSWORD"
              FRIGATE_RTSP_PASSWORD2: "MYPASSWORD"


#démarre le container portainer
Avec docker compose ou en cli :
Docker-compose :

      docker compose up -d frigate
#ACCES FRIGATE URL :
    http://[PIIPADDRESS]:5008


#install container Hailo-8L-api-detector

      git clone https://github.com/gb-0001/hailo-8L-api-detector.git
      cd hailo-8L-api-detector
      docker compose up -d hailo-8L-api-detector

#HAILO_8L api_url: http://PIIPADDRESS:8080/v1/vision/detection






