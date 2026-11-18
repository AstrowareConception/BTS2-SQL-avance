-- Vérification NON DESTRUCTIVE de la base au premier démarrage.
USE centre_culturel;
SELECT 'participants' AS objet, COUNT(*) AS nombre FROM participants
UNION ALL SELECT 'activites', COUNT(*) FROM activites
UNION ALL SELECT 'inscriptions', COUNT(*) FROM inscriptions
UNION ALL SELECT 'journal_inscriptions', COUNT(*) FROM journal_inscriptions;

SELECT COUNT(*) AS nb_confirmees,
       COALESCE(SUM(montant), 0) AS recettes
FROM inscriptions WHERE statut = 'confirmee';

SELECT IF(
  (SELECT COUNT(*) FROM participants) = 6
  AND (SELECT COUNT(*) FROM activites) = 7
  AND (SELECT COUNT(*) FROM inscriptions) = 12
  AND (SELECT COUNT(*) FROM journal_inscriptions) = 0
  AND (SELECT COUNT(*) FROM inscriptions WHERE statut = 'confirmee') = 7
  AND (SELECT COALESCE(SUM(montant),0) FROM inscriptions
       WHERE statut = 'confirmee') = 258.00,
  'OK', 'ERREUR'
) AS validation_initialisation;
