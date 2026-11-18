# BTS SIO SLAM 2e année — TP SQL avancé

**AstroWare Conception · IRIS Nice · 2026–2027**

Kit de travaux pratiques sur les **vues**, **procédures stockées** et **triggers** sous **MySQL 8.4**.

Durée cible : **3 h 40** (220 minutes) ; sujet : **Le centre culturel — gestion des inscriptions**.

Le dépôt contient le sujet étudiant, un environnement Docker Compose, une base initialisée avec des données de démonstration, des fichiers à compléter et des tests. **Le corrigé n'est volontairement pas publié dans ce dépôt public.**

## Démarrer

1. Installer Docker Desktop (mode conteneurs Linux) et vérifier que Docker Compose V2 fonctionne.
2. Copier `.env.example` en `.env` (`cp .env.example .env` sous macOS/Linux ou `Copy-Item .env.example .env` sous PowerShell).
3. Lancer `docker compose up -d --wait` depuis le dossier racine.
4. Ouvrir **http://localhost:8082** (Adminer), choisir **MySQL**, serveur `db`, utilisateur `apprenant`, mot de passe `tp_sql_2026`, base `centre_culturel`.
5. Ouvrir **[TP_ETUDIANT.md](TP_ETUDIANT.md)** et suivre les étapes dans l'ordre.

> Ces identifiants sont uniquement destinés à un TP local. Les ports sont exposés sur `127.0.0.1`, pas sur le réseau de la classe.

## Organisation

- `TP_ETUDIANT.md` : énoncé, progression, attendus et critères d'évaluation.
- `docker-compose.yml` / `.env.example` : laboratoire commun.
- `sql/` : schéma et jeu de données injectés au **premier démarrage**.
- `etudiant/` : trois fichiers SQL à compléter et fiche de recette.
- `tests/` : contrôles de données de départ et requêtes finales.
- `docs/AIDE_MEMOIRE.md` : rappels de syntaxe sans solution.
- `.github/workflows/validation.yml` : contrôle automatisé du démarrage et des données de départ.

## Commandes utiles

```bash
docker compose up -d --wait
docker compose ps
docker compose logs --tail=80 db
docker compose down
```

**Remise à zéro intégrale, destructive :** `docker compose down -v` (supprime la base et toutes les réalisations enregistrées dans le volume). Puis `docker compose up -d --wait`.

Pour exécuter un fichier SQL depuis Adminer, utiliser l'import ou l'éditeur SQL. Pour réinitialiser, sauvegarder auparavant vos scripts `etudiant/*.sql` sur l'ordinateur.

## Référentiel

Activité mobilisée : gestion des données (BTS SIO option SLAM) — exploitation d'un langage de requêtes et développement de fonctionnalités au sein d'un SGBD. Les élèves sont évalués sur la capacité à **expliquer, tester et justifier** leur réalisation ; la syntaxe sans compréhension ne suffit pas.

Licence pédagogique du sujet : **CC BY-SA 4.0**. Les exemples, noms et adresses `.test` sont fictifs.
