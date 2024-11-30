# Git Automation: Synchronisation entre GitHub et GitLab

## Présentation

Ce projet propose une solution automatisée pour gérer et synchroniser vos dépôts Git entre **GitHub** et **GitLab**. Le script fourni s'assure que :
- Les dépôts locaux sont configurés correctement.
- Les dépôts distants (GitHub et GitLab) existent ou sont créés automatiquement.
- Les modifications locales sont poussées sur les deux plateformes en une seule commande.

---

## Fonctionnalités

## Fonctionnalités

1. **Vérification ou Initialisation du Dépôt Git Local**
2. **Ajout interactif des fichiers modifiés** :
   - Les fichiers modifiés ou non suivis sont affichés de manière claire dans une table conviviale.
   - L'utilisateur peut sélectionner individuellement les fichiers à ajouter au commit, avec validation des sélections.

3. **Synchronisation avec GitHub et GitLab**
4. **Création de branches distantes si nécessaire** :
   - Le script vérifie l'existence des branches sur les dépôts distants.
   - Si une branche n'existe pas, l'utilisateur est invité à confirmer sa création.
   - Les sélections non valides (ex. : numéro hors de la liste) sont ignorées avec un message d'avertissement.

5. **Gestion des commits personnalisés**

## 📂 **Affichage convivial des fichiers modifiés**

Les fichiers modifiés sont affichés dans une table bien formatée, facilitant la sélection. Exemple :

```
📂 Des fichiers non suivis ou des modifications détectées.
Voici la liste des fichiers modifiés :

┌──────┬─────────────────────────────┐
│ Index │ Fichiers modifiés           │
├──────┼─────────────────────────────┤
│ 1     │ fichier1.txt               │
│ 2     │ script.sh                  │
│ 3     │ README.md                  │
└──────┴─────────────────────────────┘
```

Selectionner ensuite sélectionner les fichiers à inclure dans le commit en entrant les numéros correspondants.

---

## 🛠️ Prérequis

Avant d'utiliser ce script, assurez-vous d'avoir :
- **Git** installé sur votre système :
```bash
git --version
```
## Structure des dossiers afin d'executer le script

Rassurer vous d'avoir le script à la racine du projet 
   ```bash
   votre_projet/
   |── script_push.sh     # Script Bash d'automatisation
   ```
# Étapes pour Utiliser le Script Git Automation

## Étape 1 : Préparer l'Environnement

1. **Installer Git**
   - Linux : `sudo apt install git`
   - macOS : `brew install git`
   - Windows : Télécharger et installer depuis [Git for Windows](https://git-scm.com/downloads).

2. **Installer GitHub CLI (`gh`)**
   - Linux/macOS : `brew install gh` ou `sudo apt install gh`.
   - Windows : Télécharger depuis [GitHub CLI](https://cli.github.com/).

3. **Installer GitLab CLI (`glab`)**
   - Linux/macOS : `brew install glab` ou `sudo apt install glab`.
   - Windows : Télécharger depuis [GitLab CLI](https://github.com/profclems/glab#installation).

4. **Configurer les CLIs**
   - GitHub : `gh auth login`
   - GitLab : `glab auth login`

5. **Configurer les Clés SSH**
- Générer une clé SSH pour chacune des plateformes :  
   ```bash
   ssh-keygen -t ed25519 -C "votre.email@exemple.com" -f ~/.ssh/id_github
   ssh-keygen -t ed25519 -C "votre.email@exemple.com" -f ~/.ssh/id_gitlab
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_github
   ssh-add ~/.ssh/id_gitlab
   ```
- Ajouter les clés SSH publiques à vos comptes GitHub et GitLab :
     ```bash
     cat ~/.ssh/id_github.pub
     cat ~/.ssh/id_gitlab.pub

---
## Étape 2 : Editer le fichier de configuration 
- ~/.ssh/config

   ```bash
   # Configuration pour GitHub
   Host github.com
   HostName github.com
   User git
   IdentityFile ~/.ssh/id_github
   IdentitiesOnly yes

   # Configuration pour GitLab
   Host gitlab.com
   HostName gitlab.com
   User git
   IdentityFile ~/.ssh/id_gitlab
   IdentitiesOnly yes
   ```

## Étape 3 : Préparer le Script

1. **Cloner le projet :**
2. **Copier le contenu du fichier**
3.	Modifiez les variables dans le fichier script_push.sh :

	- REPO_NAME, GITHUB_USER, GITLAB_USER.

4.	Rendez le script exécutable : 
   ### Rendre le script exécutable (pour l'utilisateur ou le groupe) :
   ```bash
   chmod u+x script_push.sh  # Pour l'utilisateur uniquement
   chmod g+x script_push.sh  # Pour le groupe
   ```

   ### Exécuter le script directement sans modification de permissions :
   ```bash
   bash script_push.sh
   ```

## Étape 4 : Exécuter le Script

1. Lancez le script :
   ```bash
   ./script_push.sh
   ```
## Étape 5 : Vérifier les Résultats

1. Accédez aux dépôts distants :
   - **GitHub** : `https://github.com/<VotreNomUtilisateur>/<NomDépôt>`
   - **GitLab** : `https://gitlab.com/<VotreNomUtilisateur>/<NomDépôt>`
