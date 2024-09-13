# Système de Détection sur Raspberry Pi 5 avec Frigate et Hailo 8L

Cette procédure décrit les étapes pour configurer un système de détection de personnes sur un Raspberry Pi 5, en utilisant Frigate et un détecteur Hailo 8L.



## 1. Retour sur l'utilisation du CPU sur RPI5

- **85% de CPU** : 5 caméras RTSP avec une source vidéo de 1920x1080 à 30fps, utilisant le modèle `yolov6n.hef` (640x640) avec une taille de batch de 8.
- **19% de CPU** : 2 caméras RTSP avec une source vidéo de 1920x1080 à 30fps, utilisant le même modèle `yolov6n.hef` avec une taille de batch de 8.

## 2. Journaux du Conteneur Hailo-8L

Exemple de sortie des journaux du detecteur :
```plaintext
2024-09-02 14:41:25.403 [web_log.py:211] INFO:172.20.0.2 [02/Sep/2024:13:41:25 +0100] "POST /v1/vision/detection HTTP/1.1" 200 675 "-" "python-requests/2.32.3"
2024-09-02 14:41:25.490 [web_server.py:202] INFO:Request ID: 025a5949-dbdd-49d0-b587-de37a20c93d3; Found person; roundtrip, ms: 27; inference, ms: 14
2024-09-02 14:41:25.491 [web_log.py:211] INFO:172.20.0.2 [02/Sep/2024:13:41:25 +0100] "POST /v1/vision/detection HTTP/1.1" 200 675 "-" "python-requests/2.32.3"
2024-09-02 14:41:25.611 [web_server.py:202] INFO:Request ID: 5ad0d13f-c143-4780-a216-502f327c491a; Found person; roundtrip, ms: 28; inference, ms: 14
```

## 3. Fusion de Projets

Pour faire fonctionner sur un Raspberry Pi 5 un équivalent de l'API Deepstack pour Frigate, j'ai fusionné les deux projets suivants :

- **Projet 1** : Hailo Object Detection Mini Server - [Source](https://github.com/serg987/hailo-mini-od-server)
- **Projet 2** : pi-ai-kit-ubuntu pour la préparation du host RPI5 - [Source](https://github.com/canonical/pi-ai-kit-ubuntu)

Pour plus de détails, consultez les README respectifs :
- [README_pi-ai-kit-ubuntu.md](https://github.com/gb-0001/hailo-8L-api-detector/blob/master/README_pi-ai-kit-ubuntu.md)

## 4. Prérequis sur RPI5

### 4.1 Installation du Système d'Exploitation

1. Installez `Bookworm 12.6 (OS 64)` sur votre Raspberry Pi 5.
   - [Documentation Raspberry Pi](https://www.raspberrypi.com/documentation/accessories/ai-kit.html)
   - [Guide détaillé sur GitHub](https://github.com/gb-0001/hailo-8L-api-detector/blob/master/doc/about.adoc)

### 4.2 Installation de Hailo 8L

1. Suivez les instructions fournies dans le lien suivant pour installer Hailo 8L :
   - [Documentation Hailo](https://community.hailo.ai/t/hailo-8l-on-ubuntu-24-04-using-docker/1771)

## 5. Configuration et Déploiement

### 5.1 Préparation RPI5

1. Préparation :
   - ```bash
     #install du rpi 64bit
        sudo apt update
        sudo apt upgrade -y
        
        #passer le GPU en 128Mo mini mieux 256Mo
        sudo raspi-config
        ==> 4 Performance Options 
        ==> P2 GPU Memory
        ==> 128  ou 256
        
        #pour la config frigate et le stockage video
        mkdir ~/frigate-nvr
        mkdir ~/frigate-nvr/storage
     ```

2. Installation docker + portainer :
   - ```bash
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
     ```

     #URL d'accès:

     http://[RPI5-IPADDRESS]:9000


### 5.2 Lancement du Conteneur Frigate

1. Lancez le conteneur à l'aide de Docker-compose :

   - #PREREQUIS CONFIGURATION container FRIGATE docker-compose.yml ==> [frigate-nvr/docker-compose.yml] (https://github.com/gb-0001/hailo-8L-api-detector/blob/master/frigate-nvr/docker-compose.yml)

   - Modifier le path ~/frigate-nvr dans docker-compose.yml:

       volumes:

         - /etc/localtime:/etc/localtime:ro

         - ~/frigate-nvr/config.yml:/config/config.yml

         - ~/frigate-nvr/storage:/media/frigate

    - Modifier "MYPASSWORD" pour le password des CAM1 ET CAM2 dans docker-compose.yml:

      environment:

        FRIGATE_RTSP_PASSWORD: "MYPASSWORD" # RTSP CAM1 PASSWORD

        FRIGATE_RTSP_PASSWORD2: "MYPASSWORD" # RTSP CAM2 PASSWORD


   - #PREREQUIS CONFIGURATION FRIGATE config.yml ==> [frigate-nvr/config/config.yml] (https://github.com/gb-0001/hailo-8L-api-detector/blob/master/frigate-nvr/config/config.yml)

     Modifier [RPI5-IPADDRESS] +  [USERCAM] + [IPCAM1] + PORT ==> :554/live/ch0:

       detectors:

         deepstack:

            api_url: http://[RPI5-IPADDRESS]:8080/v1/vision/detection

        cameras:

          CAM1: #Name for your comment

            ffmpeg:

            inputs:

                - path: rtsp://[USERCAM]:{FRIGATE_RTSP_PASSWORD}@[IPCAM1]:554/live/ch0
            ...


    # Lancement du container Frigate:

   - ```bash
     docker compose up -d frigate
     ```
     #ACCES FRIGATE URL :

     http://[RPI5-IPADDRESS]:5008



### 5.3 Installation du container Hailo-8L-api-detector

1. Lancez le conteneur à l'aide de Docker-compose :

   - /!\ Warning possible mais pas important pour       - DISPLAY=${DISPLAY}

   - ```bash
     git clone https://github.com/gb-0001/hailo-8L-api-detector.git

     cd hailo-8L-api-detector

     docker compose up -d hailo-8l-api-detector
     ```

     #ACCES HAILO_8L api_url:
    
     http://[RPI5-IPADDRESS]:8080/v1/vision/detection


2. Vérifiez les journaux pour vous assurer que tout fonctionne correctement :
   - ```bash
      docker logs hailo-8L-api-detector
     ```

## 6. Références

- [Hailo Mini Object Detection Server](https://github.com/serg987/hailo-mini-od-server)
- [pi-ai-kit-ubuntu](https://github.com/canonical/pi-ai-kit-ubuntu)
- [Documentation Hailo Community](https://community.hailo.ai/t/hailo-8l-on-ubuntu-24-04-using-docker/1771)




