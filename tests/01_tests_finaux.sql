-- Vérifications DE LECTURE, à exécuter UNE FOIS les objets créés.
-- Les résultats chiffrés ci-dessous sont attendus AVANT le test UPDATE de l'inscription 3.
-- Si vous l'avez déjà modifiée, les calculs sont volontairement différents.
USE centre_culturel;

SHOW FULL TABLES WHERE Table_type = 'VIEW';
SHOW TRIGGERS;
SHOW PROCEDURE STATUS WHERE Db = 'centre_culturel';

SELECT * FROM v_participants_publics ORDER BY id;
SELECT * FROM v_inscriptions_detail ORDER BY id_inscription;
SELECT * FROM v_recettes_activites ORDER BY id_activite;

SELECT COUNT(*) AS nb_lignes FROM v_inscriptions_detail;
SELECT COALESCE(SUM(recette), 0) AS montant_total
FROM v_recettes_activites;

CALL sp_inscriptions_participant(1);
CALL sp_total_confirme(1, @total_lea);
SELECT @total_lea AS total_initial_lea;
CALL sp_total_confirme(6, @total_emma);
SELECT @total_emma AS total_initial_emma;

-- Pour les essais d'écriture et les échecs VOLONTAIRES,
-- suivre la fiche etudiant/04_recette.md, plutôt que d'exécuter
-- plusieurs UPDATE en bloc sans comprendre leurs conséquences.
