-- BTS SIO 2A · TP Centre culturel
-- Étape 1 : les vues. Complétez ici vos trois CREATE VIEW.
-- Exécutez les CREATE VIEW dans MySQL, puis testez les résultats avec SELECT.
USE centre_culturel;

-- MISSION 1.1 : v_participants_publics
-- Colonnes : id, nom, ville (sans email).
-- Votre SQL :

-- MISSION 1.2 : v_inscriptions_detail
-- Colonnes : id_inscription, nom_participant, titre_activite,
--            montant, statut, date_inscription.
-- Votre SQL :

-- MISSION 1.3 : v_recettes_activites
-- Colonnes : id_activite, titre_activite, nb_confirmees, recette.
-- Chaque activité doit apparaître, même avec zéro confirmation.
-- Indices : LEFT JOIN, GROUP BY, CASE WHEN, COUNT, SUM.
-- Votre SQL :

-- Conservez vos requêtes de contrôle ici en commentaire
-- ou dans le fichier etudiant/04_recette.md.
