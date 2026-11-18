# TP — Le centre culturel : automatiser les inscriptions

**BTS SIO · 2e année · SLAM · 2026–2027**  
**SQL avancé : vues, procédures stockées et triggers**  
**Durée : 3 h 40 (220 minutes)** · Travail individuel ou en binôme · MySQL 8.4

---

## Votre mission

Le centre culturel des Alpes-Maritimes propose des ateliers de photographie, cuisine, yoga, musique ou randonnée. Jusqu'à présent, une secrétaire consulte les inscriptions en recopiant des requêtes SQL, calcule les recettes dans un tableur et note les changements de statut à la main.

Un nouvel outil de gestion va bientôt être développé. Avant de toucher au PHP ou à l'API, votre responsable technique vous confie **trois évolutions directement dans le SGBD** :

1. Préparer des consultations SQL simples, réutilisables et adaptées à différents utilisateurs.
2. Centraliser des traitements que plusieurs applications pourront appeler.
3. Conserver une trace automatique des changements et empêcher une annulation interdite.

Vous devez écrire les objets SQL, **les exécuter**, constater leur effet et en fournir des preuves. Un objet qui se crée sans erreur mais qui ne donne pas le bon résultat n'est pas terminé.

**Important :** ce TP utilise délibérément les mêmes mécanismes que le cours de la boutique, mais dans un nouveau métier. N'ajoutez ni serveur PHP, ni ORM, ni API : **le travail porte sur MySQL**.

## Objectifs à atteindre

À la fin du TP, vous saurez construire et interroger une **vue**, écrire et appeler une **procédure stockée** utilisant des paramètres IN et OUT, créer des **triggers BEFORE/AFTER UPDATE** avec OLD et NEW, employer SIGNAL SQLSTATE pour refuser une opération, puis vérifier les données avant et après modification.

Vous devrez également distinguer **vue / table**, **procédure / trigger** et **contrainte de table / règle automatisée**.

## Planning de votre séance

| Étape | Durée | Production |
|---|---:|---|
| 0. Démarrage et exploration | 20 min | Base accessible, schéma compris |
| 1. Les vues | 55 min | Trois vues documentées |
| 2. Les procédures stockées | 55 min | Deux procédures testées |
| 3. Les triggers | 65 min | Deux triggers et preuves de comportement |
| 4. Recette et livraison | 25 min | Vérifications, compte rendu |
| **Total** | **220 min** | **3 h 40** |

Les défis complémentaires sont facultatifs : ils occupent les étudiants qui ont terminé avant la fin de la séance.

---

## 0 — Démarrer et comprendre la base (20 min)

**Prérequis :** Docker Desktop démarré, Docker Compose V2 et un navigateur.

Depuis le dossier du dépôt, créez le fichier de paramètres et démarrez :

```powershell
Copy-Item .env.example .env
docker compose up -d --wait
docker compose ps
```

Sous macOS ou Linux, remplacez Copy-Item par cp.

Ouvrez **http://localhost:8082** : système **MySQL**, serveur **db**, utilisateur **apprenant**, mot de passe **tp_sql_2026**, base **centre_culturel**.

Dans Adminer, observez les quatre tables :

| Table | Rôle |
|---|---|
| participants | Personnes inscrites, avec nom, ville et adresse e-mail |
| activites | Catalogue des ateliers, tarif et indicateur de disponibilité au catalogue |
| inscriptions | Une personne s'inscrit à une activité avec un montant et un statut |
| journal_inscriptions | Historique qui sera rempli plus tard par votre trigger |

**Les trois statuts sont :** en_attente, confirmee et annulee. Le champ montant est le montant enregistré au moment de l'inscription ; ne le remplacez pas par le prix courant de l'activité dans les calculs de recettes.

Exécutez le contenu de **tests/00_donnees_depart.sql** dans Adminer. Avant vos modifications, vous devez obtenir **6 participants**, **7 activités**, **12 inscriptions**, **7 inscriptions confirmées** et **258,00 € de recettes confirmées**. Le journal contient **0 ligne**.

**À réaliser :**

- Écrivez une requête SELECT montrant le nom des participants et leur ville.
- Affichez les inscriptions de Léa Martin (participant 1) grâce à un JOIN.
- Expliquez pourquoi la base ne doit pas compter une inscription annulée comme une recette.

> Ne lancez jamais sql/01_schema.sql ou sql/02_donnees.sql une deuxième fois sur une base déjà initialisée. Ils sont importés automatiquement au premier démarrage du volume Docker.

---

## 1 — Des vues : présenter les bonnes informations (55 min)

**Problème métier :** l'accueil du centre, la direction et un futur site web ne souhaitent pas afficher exactement les mêmes colonnes. Il faut proposer des consultations fiables et réutilisables sans recopier des SELECT dans chaque application.

Travaillez dans **etudiant/01_vues.sql**. Chaque objet doit être créé avec CREATE VIEW ... AS SELECT ..., puis testé à l'aide d'un SELECT sur son nom.

### Mission 1.1 — L'annuaire de l'accueil (facile, 10 min)

Créez la vue **v_participants_publics** qui présente exactement **id, nom, ville** de chaque participant.

**Contraintes :** 6 lignes attendues ; la colonne email ne doit pas figurer dans le résultat. L'accueil n'a pas besoin de connaître les adresses e-mail pour cette consultation.

**Questions :** Pourquoi parle-t-on de « table virtuelle » ? Cette vue protège-t-elle réellement les e-mails si le même utilisateur peut toujours interroger la table participants ? Justifiez.

### Mission 1.2 — Le tableau de suivi (intermédiaire, 20 min)

Créez **v_inscriptions_detail**, avec **une ligne par inscription** et les colonnes, dans cet ordre :

- id_inscription : identifiant de l'inscription ;
- nom_participant : nom de la personne ;
- titre_activite : activité choisie ;
- montant, statut, date_inscription.

Utilisez les jointures entre inscriptions, participants et activites. **12 lignes attendues**.

**Vérifications :** l'inscription 1 doit relier Léa Martin à Photo urbaine et afficher 35,00 ; l'inscription 3 doit relier Léa Martin à Yoga du samedi et avoir le statut en_attente.

**Question :** Pourquoi utiliser des alias de colonnes ? Que gagnerait un futur écran de gestion à lire cette vue ?

### Mission 1.3 — Les recettes par activité (approfondissement guidé, 25 min)

Créez **v_recettes_activites** avec une ligne pour **chacune des 7 activités**, même sans inscription confirmée. Colonnes demandées :

**id_activite, titre_activite, nb_confirmees, recette**.

- nb_confirmees compte seulement les inscriptions dont le statut est confirmee.
- recette additionne uniquement les montants de ces inscriptions.
- Pour une activité sans inscription confirmée, les deux résultats doivent être **0**.

**Indices :** LEFT JOIN pour conserver les activités sans correspondance ; GROUP BY ; CASE WHEN ; SUM ; COUNT ; COALESCE si nécessaire.

**Résultats de référence avant tests des triggers :** Photo urbaine = 2 confirmées et **70,00 €** ; Cuisine italienne = 2 confirmées et **90,00 €** ; Atelier poterie = 2 confirmées et **80,00 €** ; Yoga du samedi = 1 confirmée et **18,00 €** ; les trois autres activités = **0,00 €**. Total = **258,00 €**.

**Piège volontaire :** une inscription en_attente a un montant, mais ce montant n'est pas encore une recette confirmée.

---

## 2 — Procédures stockées : appeler un traitement (55 min)

**Problème métier :** une application mobile et le futur back-office devront retrouver les inscriptions d'une personne et calculer son total confirmé. Il serait dommage de réécrire des requêtes différentes selon le client.

Travaillez dans **etudiant/02_procedures.sql**. Souvenez-vous que **DELIMITER est une commande du client MySQL**, utile lorsque le corps d'une procédure contient des points-virgules. Dans Adminer, utilisez l'éditeur SQL et l'option de délimiteur si nécessaire ; en cas de difficulté, passez par la commande MySQL indiquée dans l'aide-mémoire.

### Mission 2.1 — Consulter les inscriptions d'une personne (25 min)

Écrivez **sp_inscriptions_participant**, avec le paramètre **IN p_participant_id INT**.

Cette procédure doit renvoyer, pour la personne choisie :

**id_inscription, titre_activite, montant, statut**, triés par id_inscription croissant.

**Appel attendu :** CALL sp_inscriptions_participant(1);

Vous devez obtenir **trois inscriptions** pour Léa Martin : Photo urbaine (35 € confirmée), Yoga du samedi (18 € en attente), Atelier poterie (40 € confirmée).

Testez également le participant 6 puis un identifiant inexistant (999). Une liste vide n'est pas une erreur SQL.

### Mission 2.2 — Calculer le montant confirmé (30 min)

Écrivez **sp_total_confirme**, avec deux paramètres :

- **IN p_participant_id INT** : personne à étudier ;
- **OUT p_total DECIMAL(10,2)** : somme calculée par la procédure.

Additionnez uniquement les montants des inscriptions dont le statut est confirmee. Si rien ne correspond, renvoyez 0 et non NULL.

Utilisez **SELECT ... INTO**, **SUM** et **COALESCE**.

**Tests obligatoires :**

```sql
CALL sp_total_confirme(1, @total);
SELECT @total AS total_lea;
-- Résultat initial attendu : 75.00

CALL sp_total_confirme(6, @total);
SELECT @total AS total_emma;
-- Résultat initial attendu : 0.00
```

**Questions :** Quelle différence entre IN et OUT ? Pourquoi la procédure ne s'exécute-t-elle pas lorsqu'une ligne est simplement modifiée par un UPDATE ?

---

## 3 — Triggers : agir automatiquement au bon moment (65 min)

**Problème métier :** chaque changement d'état doit pouvoir être expliqué. En outre, le centre interdit l'annulation directe d'une inscription déjà confirmée : un remboursement doit être étudié séparément.

Travaillez dans **etudiant/03_triggers.sql**. Il s'agit de triggers **FOR EACH ROW**, comme dans le cours MySQL. Vous n'avez pas à créer un trigger par instruction entière.

### Mission 3.1 — Journaliser un changement de statut (30 min)

Créez **tr_journal_statut**, déclenché **AFTER UPDATE ON inscriptions**.

Il doit ajouter dans **journal_inscriptions** une ligne contenant l'identifiant de l'inscription, OLD.statut et NEW.statut **seulement si le statut change réellement**.

La date est fournie par la valeur DEFAULT de la table de journal ; il n'est pas nécessaire de la transmettre.

**Test :** vérifiez que le journal est vide, puis exécutez :

```sql
UPDATE inscriptions
SET statut = 'confirmee'
WHERE id = 3;

SELECT * FROM journal_inscriptions;
```

**Attendu :** une seule trace, inscription 3, ancien statut en_attente, nouveau statut confirmee.

Recommencez exactement le même UPDATE : **aucune deuxième trace** ne doit apparaître. Expliquez l'utilité de la condition comparant OLD et NEW.

### Mission 3.2 — Refuser une annulation injustifiée (35 min)

Créez **tr_interdire_annulation**, déclenché **BEFORE UPDATE ON inscriptions**.

Si **OLD.statut = 'confirmee'** et **NEW.statut = 'annulee'**, le trigger doit arrêter l'opération avec :

```sql
SIGNAL SQLSTATE '45000'
  SET MESSAGE_TEXT = 'Remboursement requis avant annulation';
```

**Test volontairement en erreur :**

```sql
UPDATE inscriptions
SET statut = 'annulee'
WHERE id = 1;
```

La requête doit être refusée. Vérifiez ensuite que le statut de l'inscription 1 est **toujours confirmee** et qu'aucune trace supplémentaire n'a été ajoutée au journal.

**Questions :** Pourquoi BEFORE ici, mais AFTER pour l'historique ? Pourquoi une contrainte CHECK sur les valeurs possibles de statut ne suffit-elle pas à interdire cette transition particulière ?

**Attention :** une erreur attendue est une **preuve de réussite du contrôle**. N'effacez pas le trigger parce qu'il refuse ce cas !

---

## 4 — Recette, justification et livraison (25 min)

Vos cinq objets SQL doivent maintenant coexister. Effectuez la **recette fonctionnelle** en suivant **etudiant/04_recette.md**.

Vérifiez en particulier :

1. La vue d'annuaire ne présente pas email.
2. La vue de suivi renvoie exactement 12 inscriptions.
3. La vue de recettes totalise initialement 258,00 €, puis **276,00 €** après confirmation de l'inscription 3.
4. La procédure du participant 1 calcule initialement 75,00 €, puis **93,00 €** après cette confirmation.
5. La journalisation produit une seule trace malgré deux UPDATE identiques ; une annulation interdite échoue sans modifier les données.

**À remettre :** les trois fichiers SQL complétés, le fichier de recette renseigné (ou une version PDF / Markdown) et **au moins cinq preuves** : requêtes/résultats ou captures lisibles. Chaque preuve doit montrer **ce que vous avez demandé**, **ce que MySQL a répondu** et **pourquoi c'est correct**.

**Question de synthèse :** dans ce centre culturel, quel mécanisme répondrait à chacun de ces besoins : « présenter un rapport de recettes », « recalculer le total d'une personne à la demande », « refuser automatiquement une transition interdite » ? Justifiez les trois choix.

---

## Défis facultatifs — pour aller plus loin (15 à 25 min)

**Défi A.** Créez une vue v_inscriptions_en_attente qui ne présente que les inscriptions en_attente. Au départ, les identifiants attendus sont **3, 8 et 12**.

**Défi B.** Proposez (sans obligation de coder) une procédure permettant de créer une inscription à partir de deux identifiants. Listez **trois contrôles à effectuer** avant INSERT : participant existant, activité active et absence de doublon. Expliquez pourquoi utiliser le prix affiché dans le catalogue sans en enregistrer une copie pourrait fausser l'historique des recettes.

**Défi C.** Décrivez comment l'appel à sp_total_confirme pourrait être effectué depuis un repository PHP utilisant PDO, sans écrire d'API complète. Identifiez le rôle de l'application et celui de MySQL.

---

## Évaluation indicative /20

| Critère | Points |
|---|---:|
| Mise en route, exploration et compréhension des données | 2 |
| Vues : annuaire (1), suivi (2), recettes (3) | 6 |
| Procédures : liste par participant (2), total avec OUT (3) | 5 |
| Triggers : journalisation (2,5), interdiction (2,5) | 5 |
| Recette, preuves et explications | 2 |
| **Total** | **20** |

Un résultat juste obtenu par une simple copie sans compréhension devra pouvoir être **expliqué lors d'une courte démonstration**. Un fichier non exécuté ne constitue pas une preuve de fonctionnement.

## Aide et dépannage

Consultez **docs/AIDE_MEMOIRE.md** avant de demander de l'aide. En cas de problème de port, modifiez MYSQL_PORT ou ADMINER_PORT dans votre fichier .env, puis redémarrez Compose. Pour réinitialiser complètement les données, utilisez docker compose down -v **en sachant que toutes les modifications de la base seront détruites** ; vos fichiers SQL sur le disque seront conservés.

*AstroWare Conception · IRIS Nice · CC BY-SA 4.0*
