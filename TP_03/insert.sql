CREATE SCHEMA IF NOT EXISTS teams;
 
USE teams;

CREATE TABLE IF NOT EXISTS games(
  victory INTEGER,
  observations TEXT,
  match_date DATE
);

INSERT INTO games (victory, observations, match_date) VALUES (8, "This game was so hard !", "2019-08-01");

/*
Pour ce script je pars du principe que l'utilisateur manager existe. Si la base de données n'existe pas
je la crée. J'ajoute également la table qui nous interèsse s'il n'existe pas.

Pour exécuter le script :
mysql -u manager -p < insert.sql
*/
