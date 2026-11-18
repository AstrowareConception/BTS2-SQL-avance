-- BTS SIO 2A · TP Centre culturel
-- Étape 3 : triggers AFTER et BEFORE UPDATE.
USE centre_culturel;

-- MISSION 3.1 : tr_journal_statut
-- AFTER UPDATE ON inscriptions FOR EACH ROW
-- Journaliser UNIQUEMENT quand OLD.statut et NEW.statut diffèrent.
-- Colonnes à renseigner : inscription_id, ancien_statut, nouveau_statut.
-- Votre SQL :

-- MISSION 3.2 : tr_interdire_annulation
-- BEFORE UPDATE ON inscriptions FOR EACH ROW
-- Refuser 'confirmee' -> 'annulee' avec SIGNAL SQLSTATE '45000'
-- et le message fourni dans l'énoncé.
-- Votre SQL :

-- Rappel : placez vos CREATE TRIGGER entre DELIMITER //
-- et DELIMITER ;, avec BEGIN ... END//.

-- TESTS À FAIRE MANUELLEMENT DANS L'ORDRE, PAS AUTOMATIQUEMENT
-- (le dernier test DOIT échouer) :
-- SELECT * FROM journal_inscriptions;
-- UPDATE inscriptions SET statut = 'confirmee' WHERE id = 3;
-- SELECT * FROM journal_inscriptions;
-- UPDATE inscriptions SET statut = 'confirmee' WHERE id = 3;
-- SELECT * FROM journal_inscriptions;
-- UPDATE inscriptions SET statut = 'annulee' WHERE id = 1;
-- SELECT id, statut FROM inscriptions WHERE id = 1;
