-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.
--\c tournament;
--\i tournament.sql;
create table players(
	id serial primary key, 
	name text
	);
	
create table standings(
	id serial primary key, 
	totalmatches int, 
	wins int, 
	loss int, 
	player_id int references players(id)
	);
	
create table matches(
	id serial primary key,
	player1_id int references players(id),
	player2_id int references players(id),
	winner int
	);
	
CREATE OR REPLACE VIEW public.sort_by_wins AS
	SELECT *, ROW_NUMBER() OVER(ORDER BY wins DESC, loss) FROM standings;
    
CREATE OR REPLACE VIEW public.winners AS
     SELECT *, ROW_NUMBER() OVER (ORDER BY winners_list.row_number) AS rwnum
     FROM (SELECT t1.id, t1.row_number, t1.player_id FROM sort_by_wins AS t1 WHERE t1.row_number%2=1 ORDER BY t1.row_number) AS winners_list; 
     
 CREATE OR REPLACE VIEW public.losers AS
    SELECT *, ROW_NUMBER() OVER (ORDER BY losers_list.row_number) AS rwnum
    FROM (SELECT t1.id, t1.row_number, t1.player_id FROM sort_by_wins AS t1 WHERE t1.row_number%2=0 ORDER BY t1.row_number) AS losers_list;