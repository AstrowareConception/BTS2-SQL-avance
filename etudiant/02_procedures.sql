-- BTS SIO 2A · TP Centre culturel
-- Étape 2 : les procédures. Définissez deux CREATE PROCEDURE.
USE centre_culturel;

-- MISSION 2.1 : sp_inscriptions_participant(IN p_participant_id INT)
-- Retourner les inscriptions de la personne choisie,
-- avec id_inscription, titre_activite, montant, statut.
-- Indice : SELECT ... JOIN ... WHERE ... ORDER BY ...
-- Votre SQL :

-- MISSION 2.2 : sp_total_confirme(IN p_participant_id INT,
--                                OUT p_total DECIMAL(10,2))
-- Indices : SELECT COALESCE(SUM(...),0) INTO p_total ...
-- Statut pris en compte : 'confirmee'.
-- Votre SQL :

-- Rappel : utilisez DELIMITER // avant les CREATE PROCEDURE
-- et DELIMITER ; après. Délimitez le corps BEGIN ... END//.
-- Attention : DELIMITER est une commande du client MySQL,
-- pas une instruction SQL serveur.

-- TESTS À EFFECTUER UNE FOIS LE CODE ÉCRIT :
-- CALL sp_inscriptions_participant(1);
-- CALL sp_total_confirme(1, @total);
-- SELECT @total;
