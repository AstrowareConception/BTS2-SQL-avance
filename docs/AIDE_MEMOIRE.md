# Aide-mémoire SQL — sans corrigé

Rappels des mécanismes du cours. Les exemples utilisent des noms de tables **fictifs différents du TP** : adaptez les idées, pas les noms.

## Jointures, alias et agrégats

```sql
SELECT d.id AS id_document, a.nom AS auteur
FROM documents AS d
JOIN auteurs AS a ON a.id = d.auteur_id;

SELECT a.nom, COUNT(d.id) AS nb_documents
FROM auteurs AS a
LEFT JOIN documents AS d ON d.auteur_id = a.id
GROUP BY a.id, a.nom;
```

**LEFT JOIN :** conserve les lignes de gauche lorsqu'il n'y a pas de correspondance à droite.  
**COUNT(colonne) :** ignore les valeurs NULL.  
**SUM :** calcule une somme ; si le résultat est NULL, COALESCE(..., 0) peut fournir 0.  
**CASE WHEN :** peut appliquer une condition à une valeur avant agrégation.

## Vues

```sql
CREATE VIEW v_documents_simples AS
SELECT id, titre
FROM documents;

SELECT * FROM v_documents_simples;
```

Une **vue ordinaire** enregistre une requête, pas une copie permanente des lignes. Ne confondez pas le résultat d'une vue avec une autorisation SQL : un compte pouvant interroger la table source conserve cet accès tant que ses privilèges ne changent pas.

## Procédures

```sql
DELIMITER //
CREATE PROCEDURE compter_documents(
  IN p_auteur INT,
  OUT p_nombre INT
)
BEGIN
  SELECT COUNT(*) INTO p_nombre
  FROM documents
  WHERE auteur_id = p_auteur;
END//
DELIMITER ;

CALL compter_documents(2, @nombre);
SELECT @nombre;
```

**IN** reçoit une valeur ; **OUT** expose une valeur au code appelant. **CALL** déclenche explicitement la procédure. Une procédure peut aussi exécuter un SELECT qui renvoie un jeu de résultats.

Si Adminer ne gère pas votre saisie de DELIMITER comme prévu, utilisez le client MySQL du conteneur :

```bash
docker compose exec -it db sh
MYSQL_PWD="$MYSQL_PASSWORD" mysql -u "$MYSQL_USER" "$MYSQL_DATABASE"
```

Vous pourrez alors coller une définition complète avec DELIMITER //.

## Triggers

```sql
DELIMITER //
CREATE TRIGGER tr_exemple
AFTER UPDATE ON documents
FOR EACH ROW
BEGIN
  IF OLD.titre <> NEW.titre THEN
    -- Traitement automatique à écrire ici.
    SET @exemple = 1;
  END IF;
END//
DELIMITER ;
```

**BEFORE :** avant l'opération ; peut refuser une modification.  
**AFTER :** après l'opération ; utile pour tenir un journal dans la transaction.  
**OLD.colonne :** ancienne valeur ; **NEW.colonne :** nouvelle valeur, pour UPDATE.  
**FOR EACH ROW :** MySQL déclenche le traitement pour chaque ligne affectée.

```sql
SIGNAL SQLSTATE '45000'
  SET MESSAGE_TEXT = 'Modification interdite';
```

Ce signal provoque une erreur SQL contrôlée. Vérifiez que les données n'ont pas été modifiées.

## Dépannage SQL

- **Unknown column** : vérifiez SHOW COLUMNS FROM nom_table ;
- **Table doesn't exist** : vérifiez la base sélectionnée (USE centre_culturel ;) et les noms ;
- **Procedure already exists** : lors d'une correction, DROP PROCEDURE IF EXISTS ... puis recréez ;
- **Trigger already exists** : même logique avec DROP TRIGGER IF EXISTS ... ;
- **Syntax error near END** : vérifiez vos délimiteurs et les points-virgules internes ;
- **Access denied / connexion refusée** : vérifiez que db est healthy avec docker compose ps, puis le login ;
- **Les données n'ont pas changé après modification du script d'initialisation** : normal, l'import ne se rejoue pas lorsque le volume existe. N'utilisez down -v qu'après avoir sauvegardé votre travail.

**Référence officielle :** https://dev.mysql.com/doc/refman/8.4/en/ (chapitres CREATE VIEW, CREATE PROCEDURE, CREATE TRIGGER, SIGNAL).
