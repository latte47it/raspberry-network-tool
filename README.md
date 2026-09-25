```markdown
## aggiornamento su github
cd ~/raspberry-network-tool
git status
git add .
git commit -m "Descrizione della modifica"
git push

# Raspberry Network Tool

Tool Bash per Raspberry Pi/Linux per la gestione e il controllo della rete locale.

## Funzionalità

- Informazioni sul sistema operativo
- Informazioni hardware
- Memoria RAM
- Spazio disco
- Programmi installati
- Servizi attivi
- Informazioni sulla rete
- Scansione degli host della rete locale
- Scansione delle porte
- Identificazione dei servizi
- Scansione di singoli dispositivi
- Report delle scansioni
- Menu interattivo in modalità testo

---

# Installazione

## Requisiti

Il programma richiede:

- Raspberry Pi / Linux
- Bash
- Git
- Nmap

Installazione dei pacchetti:

```bash
sudo apt update
sudo apt install git nmap
````

---

# Utilizzo

Rendere eseguibile lo script:

```bash
chmod +x raspberry-tool.sh
```

Avviare il programma:

```bash
./raspberry-tool.sh
```

Per le funzioni che richiedono privilegi amministrativi:

```bash
sudo ./raspberry-tool.sh
```

---

# GitHub

Il progetto è archiviato su GitHub:

```text
https://github.com/latte47it/raspberry-network-tool
```

Il repository utilizza l'autenticazione SSH.

---

# Configurazione Git

Configurare il nome dell'utente:

```bash
git config --global user.name "latte47it"
```

Configurare l'indirizzo email:

```bash
git config --global user.email "TUA_EMAIL"
```

---

# Configurazione SSH per GitHub

La connessione SSH permette di utilizzare GitHub senza inserire username e password ad ogni operazione.

## Creazione della chiave SSH

Sul Raspberry:

```bash
ssh-keygen -t ed25519 -C "latte47it"
```

Premere `Invio` per utilizzare il percorso predefinito:

```text
~/.ssh/id_ed25519
```

La chiave pubblica sarà:

```text
~/.ssh/id_ed25519.pub
```

Visualizzare la chiave pubblica:

```bash
cat ~/.ssh/id_ed25519.pub
```

Copiare l'intera riga visualizzata.

> ATTENZIONE: non condividere mai il file `id_ed25519`.
> La chiave privata deve rimanere segreta.

---

# Aggiungere la chiave a GitHub

Accedere al proprio account GitHub e aprire:

```text
Settings
→ SSH and GPG keys
→ New SSH key
```

Inserire:

```text
Title: PI3
```

e incollare nel campo della chiave il contenuto di:

```bash
cat ~/.ssh/id_ed25519.pub
```

Salvare la chiave.

---

# Collegare il repository locale a GitHub

Entrare nella directory del progetto:

```bash
cd ~/raspberry-network-tool
```

Impostare il repository remoto tramite SSH:

```bash
git remote set-url origin git@github.com:latte47it/raspberry-network-tool.git
```

Controllare la configurazione:

```bash
git remote -v
```

Il risultato dovrebbe essere simile a:

```text
origin  git@github.com:latte47it/raspberry-network-tool.git (fetch)
origin  git@github.com:latte47it/raspberry-network-tool.git (push)
```

---

# Test della connessione GitHub

Verificare che la connessione SSH funzioni:

```bash
ssh -T git@github.com
```

Se viene richiesta la conferma del fingerprint:

```text
Are you sure you want to continue connecting?
```

rispondere:

```text
yes
```

Una connessione corretta restituisce un messaggio simile a:

```text
Hi latte47it! You've successfully authenticated...
```

---

# Inviare il progetto su GitHub

Dopo aver modificato lo script:

```bash
cd ~/raspberry-network-tool
```

Controllare le modifiche:

```bash
git status
```

Aggiungere i file:

```bash
git add .
```

Creare un commit:

```bash
git commit -m "Aggiornamento script"
```

Inviare le modifiche a GitHub:

```bash
git push
```

La prima volta può essere necessario:

```bash
git push -u origin main
```

---

# Scaricare il progetto su un altro Raspberry

Su un nuovo computer/Raspberry:

```bash
git clone git@github.com:latte47it/raspberry-network-tool.git
```

Entrare nella directory:

```bash
cd raspberry-network-tool
```

Rendere eseguibile lo script:

```bash
chmod +x raspberry-tool.sh
```

Installare eventualmente le dipendenze:

```bash
sudo apt update
sudo apt install nmap
```

Avviare:

```bash
./raspberry-tool.sh
```

---

# Aggiornare una copia già esistente

Se il progetto è già presente sul Raspberry:

```bash
cd ~/raspberry-network-tool
```

Scaricare l'ultima versione:

```bash
git pull
```

Poi:

```bash
chmod +x raspberry-tool.sh
```

e avviare:

```bash
./raspberry-tool.sh
```

---

# Procedura rapida

## Modificare e pubblicare

```bash
cd ~/raspberry-network-tool
git add .
git commit -m "Descrizione modifica"
git push
```

## Aggiornare un altro Raspberry

```bash
cd ~/raspberry-network-tool
git pull
```

## Installare su un nuovo Raspberry

```bash
git clone git@github.com:latte47it/raspberry-network-tool.git
cd raspberry-network-tool
chmod +x raspberry-tool.sh
sudo apt install nmap
./raspberry-tool.sh
```

---

# Sicurezza

Non inserire mai nel repository:

* password
* chiavi private SSH
* token GitHub
* API key
* credenziali
* file `.env`
* configurazioni contenenti dati sensibili
* report di rete contenenti informazioni private

La chiave privata SSH:

```text
~/.ssh/id_ed25519
```

deve rimanere esclusivamente sul dispositivo autorizzato.

La chiave pubblica:

```text
~/.ssh/id_ed25519.pub
```

può invece essere registrata nelle impostazioni SSH di GitHub.

````

### Piccola aggiunta che ti consiglio

Visto che il progetto sta crescendo, nella parte iniziale del README possiamo aggiungere anche un **menu delle funzioni disponibili**, per esempio:

```text
==========================================
       RASPBERRY NETWORK TOOL
==========================================

1) Informazioni sistema
2) Memoria RAM
3) Spazio disco
4) Programmi installati
5) Servizi attivi
6) Informazioni rete
7) Dispositivi della rete
8) Scansione porte
9) Scansione servizi
10) Scansione completa
0) Esci
````

