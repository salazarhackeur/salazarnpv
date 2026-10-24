# Pack de déploiement — salazardasilva

Ce pack prépare un service Xray **VLESS + WebSocket**. Sur Render, le TLS public est terminé par le proxy HTTPS de l'hébergeur ; le conteneur reçoit ensuite la connexion WebSocket en HTTP interne.

## Paramètres
- Profil : `salazardasilva`
- Protocole : VLESS
- Transport : WebSocket
- Chemin : `/salazardasilva`
- UUID initial : `57d3bf9e-c3ea-4ff0-b95f-7889d5cbaa30`
- Port web : `10000` (Render définit `PORT`)
- Xray écoute localement sur `127.0.0.1:10001`

Dans VLESS, `salazardasilva` est le nom/étiquette du profil, pas un nom d'utilisateur classique : l'identifiant réel est l'UUID.

## Déploiement Render
1. Décompresse le ZIP et pousse les fichiers dans un nouveau dépôt GitHub.
2. Dans Render, choisis **New Web Service**, connecte ce dépôt et sélectionne **Docker**.
3. Ajoute ces variables d'environnement :
   - `CLIENT_UUID` = `57d3bf9e-c3ea-4ff0-b95f-7889d5cbaa30`
   - `WS_PATH` = `/salazardasilva`
4. Lance le déploiement et attends le statut **Live**.
5. Ouvre l'URL HTTPS attribuée par Render. La page d'accueil doit afficher `salazardasilva websocket service is running`.
6. Cette page teste seulement la réponse HTTP du conteneur. Il faut ensuite tester la connexion VLESS dans NapsternetV.

## Paramètres NapsternetV après déploiement
- Address/Server : hôte Render sans `https://`
- Port : `443`
- UUID : valeur de `CLIENT_UUID` ci-dessus
- Encryption : `none`
- Network : `ws`
- TLS/Security : `tls`
- SNI/Server Name : hôte Render
- WebSocket Host : hôte Render
- WebSocket Path : `/salazardasilva`
- Remark/profil : `salazardasilva`

Lien modèle (remplace `VOTRE-HOTE-RENDER.onrender.com` par l'hôte réellement attribué) :
`vless://57d3bf9e-c3ea-4ff0-b95f-7889d5cbaa30@VOTRE-HOTE-RENDER.onrender.com:443?encryption=none&security=tls&sni=VOTRE-HOTE-RENDER.onrender.com&type=ws&host=VOTRE-HOTE-RENDER.onrender.com&path=%2Fsalazardasilva#salazardasilva`

## Limites importantes
- Le pack n'est pas encore hébergé : aucune URL publique n'existe avant le déploiement.
- Le plan gratuit peut dormir, limiter les heures ou changer ses conditions ; un mois de disponibilité n'est pas garanti.
- Les redéploiements/redémarrages peuvent interrompre les connexions WebSocket.
- Respecte les conditions de l'hébergeur et les lois applicables.

Documentation : https://github.com/XTLS/Xray-core et https://render.com/docs/websocket
